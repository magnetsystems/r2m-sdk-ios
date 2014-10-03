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

#import <Kiwi/Kiwi.h>
#import "MMControllerConfigurationRegistry.h"
#import "MMLogger.h"

SPEC_BEGIN(MMControllerConfigurationRegistrySpec)

describe(@"MMControllerConfigurationRegistry", ^{
    
    context(@"when calling sharedConfigurationRegistry", ^{
        
        it(@"should return a singleton", ^{
            MMLogger *sharedLogger = [[MMLogger alloc] init];
            [MMLogger stub:@selector(sharedLogger) andReturn:sharedLogger];
            [[sharedLogger should] receive:@selector(verbose:) withCount:1 arguments:any()];
            
            NSDictionary *sharedConfigurationRegistry = [MMControllerConfigurationRegistry sharedConfigurationRegistry];
             NSDictionary *anotherSharedConfigurationRegistry = [MMControllerConfigurationRegistry sharedConfigurationRegistry];
            [[sharedConfigurationRegistry should] beIdenticalTo:anotherSharedConfigurationRegistry];
        });
        
        it(@"should should read ControllerConfigurations.plist correctly", ^{
            NSDictionary *sharedConfigurationRegistry = [MMControllerConfigurationRegistry sharedConfigurationRegistry];
            NSDictionary *stackOverflowConfiguration = sharedConfigurationRegistry[@"StackOverflow"];
            [[stackOverflowConfiguration[@"BaseURL"] should] equal:@"http://stackoverflow.com"];
            [[stackOverflowConfiguration[@"TimeoutInterval"] should] beNil];
            [[stackOverflowConfiguration[@"AllowInvalidCertificates"] should] beNil];
            
            NSDictionary *gitHubConfiguration = sharedConfigurationRegistry[@"GitHub"];
            [[gitHubConfiguration[@"BaseURL"] should] equal:@"https://github.com"];
            [[gitHubConfiguration[@"TimeoutInterval"] should] equal:@3];
            [[theValue([gitHubConfiguration[@"AllowInvalidCertificates"] boolValue]) should] beYes];
        });
    });
});

SPEC_END
