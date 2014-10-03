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
#import "NSDictionary+MMUtilities.h"

SPEC_BEGIN(NSDictionaryUtilitiesSpec)

describe(@"NSDictionary+MMUtilities", ^{

    context(@"when calling firstObject with empty dictionary", ^{
        
        it(@"should return nil", ^{
            NSDictionary *dictionary = @{};
            [[[dictionary firstObject] should] beNil];
        });
    });
    
    context(@"when calling firstObject with nil", ^{
        
        it(@"should return nil", ^{
            NSDictionary *dictionary = nil;
            [[[dictionary firstObject] should] beNil];
        });
    });
    
    context(@"when calling firstObject with a non-empty dictionary", ^{
        
        it(@"should return an object", ^{
            NSString *name = @"John Appleseed";
            NSDictionary *dictionary = @{ @"name": name, @"nombre": name};
            [[[dictionary firstObject] should] equal:name];
        });
    });
});

SPEC_END
