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
#import "MMRestApiCall.h"
#import "MMStringResponseSerializer.h"

SPEC_BEGIN(MMRestApiCallSpec)

describe(@"MMRestApiCall", ^{

    context(@"when calling restApiCall", ^{
        
        it(@"should correctly initialize", ^{
            [[[MMRestApiCall restApiCall] should] beNonNil];
        });
    });
    
    context(@"when calling responseSerializer", ^{
        
        context(@"when the call returns a string", ^{
            it(@"should return a string response serializer", ^{
                MMRestApiCall *restApiCall = [MMRestApiCall restApiCall];
                restApiCall.returnsString = YES;
                [[[restApiCall responseSerializer] should] beKindOfClass:MMStringResponseSerializer.class];
            });
        });

        context(@"when the call does not return a string", ^{
            it(@"should return a JSON response serializer", ^{
                MMRestApiCall *restApiCall = [MMRestApiCall restApiCall];
                restApiCall.returnsString = NO;
                [[[restApiCall responseSerializer] should] beKindOfClass:AFJSONResponseSerializer.class];
            });
        });
    });
});

SPEC_END
