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
 
#import <Foundation/Foundation.h>

/**
 These constants indicate the level of logging that is desired.
 `MMLoggerLevelInfo` by default.
 */

typedef NS_ENUM(NSUInteger, MMLoggerLevel) {
    /**
     Log nothing.
     */
    MMLoggerLevelOff,
    /**
     Log everything.
     */
    MMLoggerLevelVerbose,
    /**
     Log debug level messages and above.
     */
    MMLoggerLevelDebug,
    /**
     Log information level messages and above.
     */
    MMLoggerLevelInfo,
    /**
     Log warning level messages and above.
     */
    MMLoggerLevelWarn,
    /**
     Log error level messages.
     */
    MMLoggerLevelError
};

/**
 These constants indicate the type of logging that is desired.
 `MMTTYLogging` by default.
 */
typedef NS_OPTIONS(NSInteger, MMLoggerOptions){
    /**
     Log to TTY.
     */
    MMTTYLogging  = 1 << 0,
    /**
     Log to a file.
     */
    MMFileLogging = 1 << 1,
};

/**
 `MMLogger` logs requests and responses made by Rest2Mobile, with an adjustable level of detail.
 
 Applications must enable the shared instance of `MMLogger` in `AppDelegate -application:didFinishLaunchingWithOptions:`:
 
 [[MMLogger sharedLogger] startLogging];
 
 */
@interface MMLogger : NSObject

/**
 The level of logging detail. See "Logging Levels" for possible values. `MMLoggerLevelInfo` by default.
 */
@property (nonatomic, assign) MMLoggerLevel level;

/**
 The type of logging. See "Logging Options" for possible values. `MMTTYLogging` by default.
 */
@property (nonatomic, assign) MMLoggerOptions options;

/**
 Retrieves the shared logger instance.
 */
+ (instancetype)sharedLogger;

/**
 Start logging requests and responses.
 */
- (void)startLogging;

/**
 Stop logging requests and responses.
 */
- (void)stopLogging;

/**
 Log a message with error level.
 
 @param message The message to be logged.
 @param ... A comma separated list of arguments to substitute into the format.
 
 */
- (void)error:(NSString *)message, ... __attribute__ ((format (__NSString__, 1, 2)));

/**
 Log a message with warning level.
 
 @param message The message to be logged.
 @param ... A comma separated list of arguments to substitute into the format.
 
 */
- (void)warn:(NSString *)message, ... __attribute__ ((format (__NSString__, 1, 2)));

/**
 Log a message with info level.
 
 @param message The message to be logged.
 @param ... A comma separated list of arguments to substitute into the format.
 
 */
- (void)info:(NSString *)message, ... __attribute__ ((format (__NSString__, 1, 2)));

/**
 Log a message with debug level.
 
 @param message The message to be logged.
 @param ... A comma separated list of arguments to substitute into the format.
 
 */
- (void)debug:(NSString *)message, ... __attribute__ ((format (__NSString__, 1, 2)));

/**
 Log a message with verbose level.
 
 @param message The message to be logged.
 @param ... A comma separated list of arguments to substitute into the format.
 
 */
- (void)verbose:(NSString *)message, ... __attribute__ ((format (__NSString__, 1, 2)));


@end

