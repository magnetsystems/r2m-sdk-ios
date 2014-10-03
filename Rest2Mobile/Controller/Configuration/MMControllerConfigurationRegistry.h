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
 `MMControllerConfigurationRegistry` helps define one or more `MMControllerConfiguraton` instances.
 A shared registry is created using ControllerConfigurations.plist.
    
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
 */

@interface MMControllerConfigurationRegistry : NSObject

/**
 Returns the singleton registry instance.
 @return A dictionary that represents ControllerConfigurations.plist.
 
 */
+ (NSDictionary *)sharedConfigurationRegistry;

@end
