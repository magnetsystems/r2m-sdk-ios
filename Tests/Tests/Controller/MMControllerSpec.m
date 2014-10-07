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
#import "MMController_Private.h"
#import "GOOGLEDistanceController.h"
#import "MMTransporter.h"
#import "MMControllerConfiguration.h"

SPEC_BEGIN(MMControllerSpec)

describe(@"MMController", ^{
    
    context(@"when called without a configuration", ^{
        it(@"should create a configuration based on the baseURL and return a call", ^{
    
            GOOGLEDistanceController *controller = [[GOOGLEDistanceController alloc] init];
            
            __block id _responseObject;
            
            [[MMTransporter sharedTransporter] stub:@selector(HTTPRequestOperationWithControllerMethod:invocation:controllerConfiguration:) andReturn:[NSBlockOperation blockOperationWithBlock:^{
                    _responseObject = @"done";
            }]];
            
            MMControllerMethod *controllerMethod = [GOOGLEDistanceController metaData][@"GOOGLEDistanceController:getDistance"];
            MMControllerConfiguration *configuration = [[MMControllerConfiguration alloc] initWithBaseURL:[NSURL URLWithString:@"http://maps.googleapis.com/"]];
            
            [[[MMTransporter sharedTransporter] should] receive:@selector(HTTPRequestOperationWithControllerMethod:invocation:controllerConfiguration:) withCount:1 arguments:controllerMethod, any(), configuration];
            
            MMCall *call = [controller getDistance:@"435 Tasso Street Palo Alto CA"
                                      destinations:@"Embarcadero Street San+Francisco"
                                            sensor:@"false"
                                              mode:@"driving"
                                          language:@"en"
                                             units:@"imperial"
                                           success:nil
                                           failure:nil];
            
            [[call.callId shouldNot] beNil];
            
            [[configuration should] equal:controller.configuration];
            
//            [[expectFutureValue(_responseObject) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:@"done"];
        });
    });
    
    context(@"when called with a configuration", ^{
        it(@"should return a call", ^{
            
            __block id _responseObject;
            
            [[MMTransporter sharedTransporter] stub:@selector(HTTPRequestOperationWithControllerMethod:invocation:controllerConfiguration:) andReturn:[NSBlockOperation blockOperationWithBlock:^{
                _responseObject = @"done";
            }]];
            
            MMControllerMethod *controllerMethod = [GOOGLEDistanceController metaData][@"GOOGLEDistanceController:getDistance"];
            MMControllerConfiguration *configuration = [[MMControllerConfiguration alloc] initWithBaseURL:[NSURL URLWithString:@"http://maps.googleapis.com/"]];
            configuration.allowInvalidCertificates = YES;
            
            GOOGLEDistanceController *controller = [[GOOGLEDistanceController alloc] initWithConfiguration:configuration];
            
            [[[MMTransporter sharedTransporter] should] receive:@selector(HTTPRequestOperationWithControllerMethod:invocation:controllerConfiguration:) withCount:1 arguments:controllerMethod, any(), configuration];
            
            MMCall *call = [controller getDistance:@"435 Tasso Street Palo Alto CA"
                                      destinations:@"Embarcadero Street San+Francisco"
                                            sensor:@"false"
                                              mode:@"driving"
                                          language:@"en"
                                             units:@"imperial"
                                           success:nil
                                           failure:nil];
            
            [[call.callId shouldNot] beNil];
            
            [[configuration should] equal:controller.configuration];
            [[theValue(controller.configuration.allowInvalidCertificates) should] beYes];
            
//            [[expectFutureValue(_responseObject) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:@"done"];
        });
    });
});

SPEC_END
