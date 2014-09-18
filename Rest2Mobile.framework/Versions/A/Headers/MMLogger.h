/**
 * Copyright (c) 2012-2014 Magnet Systems, Inc. All rights reserved.
 */
 
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MMLoggerLevel) {
    MMLoggerLevelOff,
    MMLoggerLevelVerbose,
    MMLoggerLevelDebug,
    MMLoggerLevelInfo,
    MMLoggerLevelWarn,
    MMLoggerLevelError
};

typedef NS_OPTIONS(NSInteger, MMLoggerOptions){
    MMTTYLogging  = 1 << 0,
    MMFileLogging = 1 << 1,
};

/**
 `MMLogger` logs requests and responses made by AFNetworking, with an adjustable level of detail.

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
 */
- (void)error:(NSString *)message, ... __attribute__ ((format (__NSString__, 1, 2)));

/**
 Log a message with warning level.
 */
- (void)warn:(NSString *)message, ... __attribute__ ((format (__NSString__, 1, 2)));

/**
 Log a message with info level.
 */
- (void)info:(NSString *)message, ... __attribute__ ((format (__NSString__, 1, 2)));

/**
 Log a message with debug level.
 */
- (void)debug:(NSString *)message, ... __attribute__ ((format (__NSString__, 1, 2)));

/**
 Log a message with verbose level.
 */
- (void)verbose:(NSString *)message, ... __attribute__ ((format (__NSString__, 1, 2)));


@end
