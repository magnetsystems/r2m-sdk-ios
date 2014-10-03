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
 `MMControllerConfiguration` defines configuration parameters such as the baseURL and credential for a `MMController` instance.
 New configurations can be added programmatically or using the ControllerConfigurations.plist file.
 */

@interface MMControllerConfiguration : NSObject <NSCopying, NSCoding>

/**
 * Optional.  A user can set URL for the call.
 */
@property(nonatomic, strong) NSURL *baseURL;

/**
Whether request operations should consult the credential storage for authenticating the connection. `YES` by default.

@see AFURLConnectionOperation -shouldUseCredentialStorage
*/
@property (nonatomic, assign) BOOL shouldUseCredentialStorage;

/**
The credential used by request operations for authentication challenges.

@see AFURLConnectionOperation -credential
*/
@property (nonatomic, strong) NSURLCredential *credential;

/**
The timeout interval, in seconds, for created requests. The default timeout interval is 60 seconds.

@see NSMutableURLRequest -setTimeoutInterval:
*/
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 Whether or not to trust servers with an invalid or expired SSL certificates. Defaults to `NO`.
*/
@property (nonatomic, assign) BOOL allowInvalidCertificates;

/**
 Creates and returns an `MMControllerConfiguration` object based on key-value pairs created in ControllerConfigurations.plist
 
     <!-- ControllerConfigurations.plist -->
     <?xml version="1.0" encoding="UTF-8"?>
     <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
     <plist version="1.0">
        <dict>
            <key>StackOverflow</key>
            <dict>
                <key>BaseURL</key>
                <string>http://stackoverflow.com</string>
            </dict>
            <key>GitHub</key>
            <dict>
                <key>BaseURL</key>
                <string>https://github.com</string>
                <key>TimeoutInterval</key>
                <integer>3</integer>
                <key>AllowInvalidCertificates</key>
                <true/>
            </dict>
        </dict>
     </plist>
 
 @param name The name of the configuration.
 
 @return The newly-initialized controller configuration based on values defined in ControllerConfigurations.plist
 
 */
+ (instancetype)configurationWithName:(NSString *)name;

/**
 Initializes an `MMControllerConfiguration` object with the specified base URL.
 
 @param baseURL The base URL for the controller.
 
 @return The newly-initialized controller configuration
 */
- (instancetype)initWithBaseURL:(NSURL *)baseURL;

/**
 Returns a Boolean value that indicates whether a given configuration is equal to the receiver using a comparison of the configuration properties.
 
 @param configuration The configuration with which to compare the receiver.
 
 @return YES if configuration is equivalent to the receiver (if they have the same id or if their properties are equal), otherwise NO.
*/
- (BOOL)isEqualToConfiguration:(MMControllerConfiguration *)configuration;

@end
