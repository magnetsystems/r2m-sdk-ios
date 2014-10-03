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
#import "MMControllerConfiguration.h"
#import "MMControllerConfigurationRegistry.h"

SPEC_BEGIN(MMControllerConfigurationSpec)

describe(@"MMControllerConfiguration", ^{
    
    context(@"when calling configurationWithName:", ^{
        NSDictionary *sharedConfigurationRegistry = @{
                                                      @"Magnet" : @{
                                                              @"BaseURL" : @"http://magnet.com"
                                                              },
                                                      @"Google" : @{
                                                              @"BaseURL" : @"https://google.com",
                                                              @"TimeoutInterval" : @0,
                                                              @"AllowInvalidCertificates" : @YES,
                                                              }
                                                      };
        context(@"with a unknown name", ^{
            it(@"should return nil", ^{
                [MMControllerConfigurationRegistry stub:@selector(sharedConfigurationRegistry)
                                              andReturn:sharedConfigurationRegistry];
                [[[MMControllerConfiguration configurationWithName:@"unknown"] should] beNil];
            });
        });
        
        context(@"with a known name", ^{
            
            context(@"with minimal configuration", ^{
                it(@"should return the configuration object with default values", ^{
                    [MMControllerConfigurationRegistry stub:@selector(sharedConfigurationRegistry)
                                                  andReturn:sharedConfigurationRegistry];
                    MMControllerConfiguration *controllerConfiguration = [MMControllerConfiguration configurationWithName:@"Magnet"];
                    [[controllerConfiguration should] beNonNil];
                    [[theValue(controllerConfiguration.timeoutInterval) should] equal:theValue(60)];
                    [[theValue(controllerConfiguration.allowInvalidCertificates) should] beNo];
                });
            });
            
            context(@"with full configuration", ^{
                it(@"should return the configuration object with specified values", ^{
                    [MMControllerConfigurationRegistry stub:@selector(sharedConfigurationRegistry)
                                                  andReturn:sharedConfigurationRegistry];
                    MMControllerConfiguration *controllerConfiguration = [MMControllerConfiguration configurationWithName:@"Google"];
                    [[controllerConfiguration should] beNonNil];
                    [[theValue(controllerConfiguration.timeoutInterval) should] equal:theValue(0)];
                    [[theValue(controllerConfiguration.allowInvalidCertificates) should] beYes];
                });
            });
        });
    });
    
    context(@"when calling initWithBaseURL:", ^{
        
        it(@"should correctly set the default values", ^{
            NSURL *baseURL = [NSURL URLWithString:@"http://magnet.com"];
            MMControllerConfiguration *controllerConfiguration = [[MMControllerConfiguration alloc] initWithBaseURL:baseURL];
            [[controllerConfiguration.baseURL should] equal:baseURL];
            [[theValue(controllerConfiguration.timeoutInterval) should] equal:theValue(60)];
            [[theValue(controllerConfiguration.allowInvalidCertificates) should] beNo];
        });
        
    });
    
    context(@"when calling isEqualToConfiguration:", ^{
        
        NSURL *baseURL = [NSURL URLWithString:@"http://magnet.com"];
        MMControllerConfiguration *controllerConfiguration = [[MMControllerConfiguration alloc] initWithBaseURL:baseURL];
        __block MMControllerConfiguration *otherConfiguration;
        
        beforeEach(^{
            otherConfiguration = [controllerConfiguration copy];
        });
        
        context(@"when configurations are one and the same object", ^{
            it(@"should return YES", ^{
                [[theValue([controllerConfiguration isEqualToConfiguration:controllerConfiguration]) should] beYes];
            });
        });
        
        context(@"when configuration is nil", ^{
            it(@"should return NO", ^{
                [[theValue([controllerConfiguration isEqualToConfiguration:nil]) should] beNo];
            });
        });
        
        context(@"when baseURL is different", ^{
            it(@"should return NO", ^{
                otherConfiguration.baseURL = [NSURL URLWithString:@"https://magnet.com"];
                [[theValue([controllerConfiguration isEqualToConfiguration:otherConfiguration]) should] beNo];
            });
        });
        
        context(@"when shouldUseCredentialStorage is different", ^{
            it(@"should return NO", ^{
                otherConfiguration.shouldUseCredentialStorage = YES;
                [[theValue([controllerConfiguration isEqualToConfiguration:otherConfiguration]) should] beNo];
            });
        });
        
        context(@"when credential is different", ^{
            it(@"should return NO", ^{
                NSURLCredential *credential = [NSURLCredential credentialWithUser:@"foo"
                                                                         password:@"bar"
                                                                      persistence:NSURLCredentialPersistenceForSession];
                otherConfiguration.credential = credential;
                [[theValue([controllerConfiguration isEqualToConfiguration:otherConfiguration]) should] beNo];
            });
        });
        
        context(@"when timeoutInterval is different", ^{
            it(@"should return NO", ^{
                otherConfiguration.timeoutInterval = 100;
                [[theValue([controllerConfiguration isEqualToConfiguration:otherConfiguration]) should] beNo];
            });
        });
        
        context(@"when allowInvalidCertificates is different", ^{
            it(@"should return NO", ^{
                otherConfiguration.allowInvalidCertificates = YES;
                [[theValue([controllerConfiguration isEqualToConfiguration:otherConfiguration]) should] beNo];
            });
        });
    });
    
    NSURL *baseURL = [NSURL URLWithString:@"http://magnet.com"];
    MMControllerConfiguration *controllerConfiguration = [[MMControllerConfiguration alloc] initWithBaseURL:baseURL];
    controllerConfiguration.shouldUseCredentialStorage = YES;
    controllerConfiguration.credential = [NSURLCredential credentialWithUser:@"foo"
                                                                    password:@"bar"
                                                                 persistence:NSURLCredentialPersistenceForSession];
    controllerConfiguration.timeoutInterval = 100;
    controllerConfiguration.allowInvalidCertificates = YES;
    
    context(@"when calling copyWithZone:", ^{
        
        it(@"should correctly copy the values", ^{
            
            MMControllerConfiguration *otherConfiguration = [controllerConfiguration copy];
            
            [[controllerConfiguration.baseURL should] equal:otherConfiguration.baseURL];
            [[theValue(controllerConfiguration.shouldUseCredentialStorage) should] equal:theValue(otherConfiguration.shouldUseCredentialStorage)];
            [[controllerConfiguration.credential should] equal:otherConfiguration.credential];
            [[theValue(controllerConfiguration.timeoutInterval) should] equal:theValue(otherConfiguration.timeoutInterval)];
            [[theValue(controllerConfiguration.allowInvalidCertificates) should] equal:theValue(otherConfiguration.allowInvalidCertificates)];
        });
        
    });
    
    context(@"when calling initWithCoder: / encodeWithCoder:", ^{
        
        it(@"should decode / encode", ^{
            NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:controllerConfiguration];
            [[[NSKeyedUnarchiver unarchiveObjectWithData:archive] should] equal:controllerConfiguration];
        });
    });
});

SPEC_END
