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
#import "MMCall_Private.h"

SPEC_BEGIN(MMCallSpec)

describe(@"MMCall", ^{
    
    context(@"when calling start", ^{
        
        it(@"should execute the success block of the underlying operation", ^{
            __block id _responseObject;
            MMCall *call = [[MMCall alloc] init];
            call.underlyingOperation = [NSBlockOperation blockOperationWithBlock:^{
                _responseObject = @"done";
            }];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [queue addOperation:call];
            [[theValue(call.isCancelled) should] beNo];
            [[expectFutureValue(_responseObject) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:@"done"];
        });
        
        context(@"followed by cancel", ^{
            it(@"should execute the success block of the underlying operation", ^{
                __block id _responseObject;
                MMCall *call = [[MMCall alloc] init];
                call.underlyingOperation = [NSBlockOperation blockOperationWithBlock:^{
                    _responseObject = @"done";
                }];
                NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                [queue addOperation:call];
                [call cancel];
                [[theValue(call.isCancelled) should] beYes];
//                [[expectFutureValue(_responseObject) shouldEventuallyBeforeTimingOutAfter(5.0)] beNil];
            });
        });
        
    });
});

SPEC_END
