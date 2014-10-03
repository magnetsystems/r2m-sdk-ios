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

// Taken from https://github.com/RestKit/RestKit/blob/c17a180b729028223d2825b96f707f1cbe5a06a9/Tests/Logic/Support/RKHTTPUtilitiesTest.m

#import <Kiwi/Kiwi.h>
#import "MMHTTPUtilities.h"

SPEC_BEGIN(MMHTTPUtilitiesSpec)

describe(@"MMHTTPUtilities", ^{

    context(@"when calling MMIsSpecificRequestMethod", ^{
        
        context(@"with an exact match for request method", ^{
            it(@"should return yes", ^{
                [[theValue(MMIsSpecificRequestMethod(MMRequestMethodPOST)) should] beYes];
            });
        });
        
        context(@"with any request method", ^{
            it(@"should return no", ^{
                [[theValue(MMIsSpecificRequestMethod(MMRequestMethodAny)) should] beNo];
            });
        });
        
        context(@"without an exact match for request method", ^{
            it(@"should return no", ^{
                [[theValue(MMIsSpecificRequestMethod(MMRequestMethodGET | MMRequestMethodPOST)) should] beNo];
            });
        });
    });
    
    context(@"when calling MMStringFromRequestMethod", ^{
        
        context(@"with an exact match for request method", ^{
            it(@"should return the same method string", ^{
                [[(MMStringFromRequestMethod(MMRequestMethodGET)) should] equal:@"GET"];
                [[(MMStringFromRequestMethod(MMRequestMethodPOST)) should] equal:@"POST"];
                [[(MMStringFromRequestMethod(MMRequestMethodPUT)) should] equal:@"PUT"];
                [[(MMStringFromRequestMethod(MMRequestMethodPATCH)) should] equal:@"PATCH"];
                [[(MMStringFromRequestMethod(MMRequestMethodDELETE)) should] equal:@"DELETE"];
                [[(MMStringFromRequestMethod(MMRequestMethodHEAD)) should] equal:@"HEAD"];
                [[(MMStringFromRequestMethod(MMRequestMethodOPTIONS)) should] equal:@"OPTIONS"];
            });
        });
        
        context(@"with any request method", ^{
            it(@"should return nil", ^{
                [[(MMStringFromRequestMethod(MMRequestMethodAny)) should] beNil];
            });
        });
        
        context(@"without an exact match for request method", ^{
            it(@"should return nil", ^{
                [[(MMStringFromRequestMethod(MMRequestMethodGET | MMRequestMethodPOST)) should] beNil];
            });
        });
    });
    
    context(@"when calling MMRequestMethodFromString", ^{
        
        context(@"with an exact match for request method string", ^{
            it(@"should return the same method", ^{
                [[theValue((MMRequestMethodFromString(@"GET"))) should] equal:theValue(MMRequestMethodGET)];
                [[theValue((MMRequestMethodFromString(@"POST"))) should] equal:theValue(MMRequestMethodPOST)];
                [[theValue((MMRequestMethodFromString(@"PATCH"))) should] equal:theValue(MMRequestMethodPATCH)];
                [[theValue((MMRequestMethodFromString(@"DELETE"))) should] equal:theValue(MMRequestMethodDELETE)];
                [[theValue((MMRequestMethodFromString(@"HEAD"))) should] equal:theValue(MMRequestMethodHEAD)];
                [[theValue((MMRequestMethodFromString(@"OPTIONS"))) should] equal:theValue(MMRequestMethodOPTIONS)];
            });
        });
        
        context(@"with any request method", ^{
            it(@"should throw an exception", ^{
                [[theBlock(^{
                    MMRequestMethodFromString(@"FOO");
                }) should] raiseWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"The given HTTP request method name `%@` does not correspond to any known request methods.", @"FOO"]];
            });
        });
    });
    
    context(@"when calling MMPercentEscapedQueryStringValueFromStringWithEncoding", ^{
        
        it(@"should return the correct value", ^{
            [[MMPercentEscapedQueryStringValueFromStringWithEncoding(@"hell & brimstone + earthly/delight", NSUTF8StringEncoding) should] equal:@"hell%20%26%20brimstone%20%2B%20earthly%2Fdelight"];
        });
    });
});

SPEC_END
