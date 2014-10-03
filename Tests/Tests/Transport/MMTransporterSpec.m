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
#import "MMTransporter.h"
#import "MMRestTransporter.h"
#import "MMControllerMethod.h"
#import "MMControllerConfiguration.h"

SPEC_BEGIN(MMTransporterSpec)

describe(@"MMTransporter", ^{

    context(@"when calling sharedTransporter", ^{
        
        it(@"should return a singleton", ^{
            MMTransporter *transporter = [MMTransporter sharedTransporter];
            MMTransporter *anotherTransporter = [MMTransporter sharedTransporter];
            [[transporter should] beIdenticalTo:anotherTransporter];
        });
    });
    
    context(@"when calling HTTPRequestOperationWithControllerMethod:invocation:controllerConfiguration:", ^{
        
        it(@"call the underlying rest transporter with the same parameters", ^{
            MMTransporter *transporter = [MMTransporter sharedTransporter];
            MMRestTransporter *restTransporter = [MMRestTransporter transporter];
            // Dummy values to pass assertions
            MMControllerMethod *controllerMethod = [[MMControllerMethod alloc] init];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSMutableArray instanceMethodSignatureForSelector:@selector(addObject:)]];
            MMControllerConfiguration *controllerConfiguration = [[MMControllerConfiguration alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [transporter stub:@selector(restTransporter) andReturn:restTransporter];
#pragma clang diagnostic pop
            [[restTransporter should] receive:@selector(HTTPRequestOperationWithControllerMethod:invocation:controllerConfiguration:) withCount:1 arguments:controllerMethod, invocation, controllerConfiguration];
            [transporter HTTPRequestOperationWithControllerMethod:controllerMethod invocation:invocation controllerConfiguration:controllerConfiguration];
        });
    });
    
    context(@"when calling restTransporter", ^{
        
        it(@"call the underlying rest transporter with the same parameters", ^{
            MMTransporter *transporter = [MMTransporter sharedTransporter];
            MMRestTransporter *restTransporter = [MMRestTransporter transporter];
            // Dummy values to pass assertions
            MMControllerMethod *controllerMethod = [[MMControllerMethod alloc] init];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSMutableArray instanceMethodSignatureForSelector:@selector(addObject:)]];
            MMControllerConfiguration *controllerConfiguration = [[MMControllerConfiguration alloc] init];
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [transporter stub:@selector(restTransporter) andReturn:restTransporter];
#pragma clang diagnostic pop
            [[restTransporter should] receive:@selector(HTTPRequestOperationWithControllerMethod:invocation:controllerConfiguration:) withCount:1 arguments:controllerMethod, invocation, controllerConfiguration];
            [transporter HTTPRequestOperationWithControllerMethod:controllerMethod invocation:invocation controllerConfiguration:controllerConfiguration];
        });
    });
});

SPEC_END
