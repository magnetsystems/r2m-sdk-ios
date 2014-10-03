/*
 * Copyright (c) 2014 Magnet Systems, Inc.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you
 * may not use this file except in compliance with the License. You
 * may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */
 
/* A lot of code below is taken from AFNetworkActivityLogger.m */

#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDFileLogger.h>
#import "MMLogger.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>

//#undef LOG_LEVEL_DEF // Undefine first only if needed
//#define LOG_LEVEL_DEF myLibLogLevel
//static const int myLibLogLevel = LOG_LEVEL_VERBOSE;

static int ddLogLevel;

static NSURLRequest * AFNetworkRequestFromNotification(NSNotification *notification) {
    NSURLRequest *request = nil;
    if ([[notification object] isKindOfClass:[AFURLConnectionOperation class]]) {
        request = [(AFURLConnectionOperation *)[notification object] request];
    } else if ([[notification object] respondsToSelector:@selector(originalRequest)]) {
        request = [[notification object] originalRequest];
    }

    return request;
}

@interface MMLogger ()
- (void)setupLogging;

- (void)setupFileLogging;

- (void)setupTTYLogging;
@end

@implementation MMLogger

+ (instancetype)sharedLogger {
    static MMLogger *_sharedLogger = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLogger = [[self alloc] init];
    });

    return _sharedLogger;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.level = MMLoggerLevelInfo;
    self.options = MMTTYLogging;

    return self;
}

- (void)dealloc {
    [self stopLogging];
}

- (void)startLogging {
    // Stop before you start
    [self stopLogging];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidStart:) name:AFNetworkingOperationDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingOperationDidFinishNotification object:nil];

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidStart:) name:AFNetworkingTaskDidResumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingTaskDidCompleteNotification object:nil];
#endif
    
    [self setupLogging];

    [self info:@"Start logging"];
}

- (void)stopLogging {
    [DDLog removeAllLoggers];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self info:@"Stop logging"];
}

- (void)error:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    va_end(args);
    DDLogError(@"[ERROR] %@", [[NSString alloc] initWithFormat:message arguments:args]);
}

- (void)warn:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    va_end(args);
    DDLogWarn(@"[WARN] %@", [[NSString alloc] initWithFormat:message arguments:args]);
}

- (void)info:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    va_end(args);
    DDLogInfo(@"[INFO] %@", [[NSString alloc] initWithFormat:message arguments:args]);
}


- (void)debug:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    va_end(args);
    DDLogDebug(@"[DEBUG] %@", [[NSString alloc] initWithFormat:message arguments:args]);
}

- (void)verbose:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    va_end(args);
    DDLogVerbose(@"[VERBOSE] %@", [[NSString alloc] initWithFormat:message arguments:args]);
}

#pragma mark - Private implementation

- (void)setupLogging {
    switch (self.level) {
        case MMLoggerLevelOff:{
            ddLogLevel = LOG_LEVEL_OFF;
            break;
        }
        case MMLoggerLevelVerbose: {
            ddLogLevel = LOG_LEVEL_VERBOSE;
            break;
        }
        case MMLoggerLevelDebug:{
            ddLogLevel = LOG_LEVEL_DEBUG;
            break;
        }
        case MMLoggerLevelInfo:{
            ddLogLevel = LOG_LEVEL_INFO;
            break;
        }
        case MMLoggerLevelWarn:{
            ddLogLevel = LOG_LEVEL_WARN;
            break;
        }
        case MMLoggerLevelError:{
            ddLogLevel = LOG_LEVEL_ERROR;
            break;
        }
    }

    [self setupTTYLogging];
    [self setupFileLogging];
}

- (void)setupFileLogging {
    BOOL shouldLogToFile = (self.options & MMFileLogging);
    if (shouldLogToFile) {
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
        [fileLogger setRollingFrequency:60 * 60 * 24];   // roll every day
        [fileLogger setMaximumFileSize:1024 * 1024 * 2]; // max 2mb file size
        [fileLogger.logFileManager setMaximumNumberOfLogFiles:7];

        [DDLog addLogger:fileLogger];

        [self info:@"Logging is setup (\"%@\")", [fileLogger.logFileManager logsDirectory]];
    }
}

- (void)setupTTYLogging {
    BOOL shouldLogToConsole = (self.options & MMTTYLogging);
    if (shouldLogToConsole) {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    }
}

#pragma mark - NSNotification

static void * AFNetworkRequestStartDate = &AFNetworkRequestStartDate;

- (void)networkRequestDidStart:(NSNotification *)notification {
    NSURLRequest *request = AFNetworkRequestFromNotification(notification);

    if (!request) {
        return;
    }

    objc_setAssociatedObject(notification.object, AFNetworkRequestStartDate, [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    NSString *body = nil;
    if ([request HTTPBody]) {
        body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }

    switch (self.level) {
        case MMLoggerLevelVerbose:
        case MMLoggerLevelDebug:
            [self debug:@"%@ '%@': %@ %@", [request HTTPMethod], [[request URL] absoluteString], [request allHTTPHeaderFields], body];
            break;
        case MMLoggerLevelInfo:
            [self info:@"%@ '%@'", [request HTTPMethod], [[request URL] absoluteString]];
            break;
        default:
            break;
    }
}

- (void)networkRequestDidFinish:(NSNotification *)notification {
    NSURLRequest *request = AFNetworkRequestFromNotification(notification);
    NSURLResponse *response = [notification.object response];
    NSError *error = [notification.object error];

    if (!request && !response) {
        return;
    }

    NSUInteger responseStatusCode = 0;
    NSDictionary *responseHeaderFields = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        responseStatusCode = (NSUInteger) [(NSHTTPURLResponse *)response statusCode];
        responseHeaderFields = [(NSHTTPURLResponse *)response allHeaderFields];
    }

    NSString *responseString = nil;
    if ([[notification object] respondsToSelector:@selector(responseString)]) {
        responseString = [[notification object] responseString];
    }

    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:objc_getAssociatedObject(notification.object, AFNetworkRequestStartDate)];

    if (error) {
        switch (self.level) {
            case MMLoggerLevelVerbose:
            case MMLoggerLevelDebug:
            case MMLoggerLevelInfo:
            case MMLoggerLevelWarn:
            case MMLoggerLevelError:
                [self error:@"%@ '%@' (%ld) [%.04f s]: %@", [request HTTPMethod], [[response URL] absoluteString], (long)responseStatusCode, elapsedTime, error];
            default:
                break;
        }
    } else {
        switch (self.level) {
            case MMLoggerLevelVerbose:
            case MMLoggerLevelDebug:
                [self debug:@"%ld '%@' [%.04f s]: %@ %@", (long)responseStatusCode, [[response URL] absoluteString], elapsedTime, responseHeaderFields, responseString];
                break;
            case MMLoggerLevelInfo:
                [self info:@"%ld '%@' [%.04f s]", (long)responseStatusCode, [[response URL] absoluteString], elapsedTime];
                break;
            default:
                break;
        }
    }
}

@end
