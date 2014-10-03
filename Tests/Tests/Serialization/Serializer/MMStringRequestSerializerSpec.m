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
#import "MMStringRequestSerializer.h"

SPEC_BEGIN(MMStringRequestSerializerSpec)

describe(@"MMStringRequestSerializer", ^{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://magnet.com"]];
    
    context(@"when calling requestBySerializingRequest:withParameters:error: with a HTTP method that encodes parameters in the URI", ^{
        
        NSDictionary *parameters = @{@"param1" : @"hell & brimstone + earthly/delight"};
        
        context(@"with a GET request", ^{
            
            it(@"should URL encode the request", ^{
                request.HTTPMethod = @"GET";
            });
        });
        
        context(@"with a DELETE request", ^{
            
            it(@"should URL encode the request", ^{
                request.HTTPMethod = @"DELETE";
            });
        });
        
        context(@"with a HEAD request", ^{
            
            it(@"should URL encode the request", ^{
                request.HTTPMethod = @"DELETE";
            });
        });
        
        afterEach(^{
            NSURLRequest *modifiedRequest = [[MMStringRequestSerializer serializer] requestBySerializingRequest:request withParameters:parameters error:NULL];
            [[modifiedRequest.URL.absoluteString should] equal:@"http://magnet.com?param1=hell%20%26%20brimstone%20%2B%20earthly%2Fdelight"];
        });
    });
    
    context(@"when calling requestBySerializingRequest:withParameters:error: with a HTTP method that does not encode parameters in the URI", ^{
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://magnet.com"]];
        [request setValue:@"Bar" forHTTPHeaderField:@"X-Foo"];
        
        context(@"with a string parameter", ^{
           
            NSString *parameters = @"hell & brimstone + earthly/delight";
            
            context(@"with a POST request", ^{
                
                it(@"should set the correct body and Content-Type header and retain the remaining headers", ^{
                    request.HTTPMethod = @"POST";
                });
            });
            
            context(@"with a PUT request", ^{
                
                it(@"should set the correct body and Content-Type header and retain the remaining headers", ^{
                    request.HTTPMethod = @"PUT";
                });
            });
            
            afterEach(^{
                NSURLRequest *modifiedRequest = [[MMStringRequestSerializer serializer] requestBySerializingRequest:request withParameters:parameters error:NULL];
                [[modifiedRequest.URL.absoluteString should] equal:@"http://magnet.com"];
                [[modifiedRequest.HTTPBody should] equal:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
                [[modifiedRequest.allHTTPHeaderFields[@"Content-Type"] should] equal:@"text/plain; charset=utf-8"];
                [[modifiedRequest.allHTTPHeaderFields[@"X-Foo"] should] equal:@"Bar"];
            });
        });
        
        context(@"with a non-string parameter which can be stringified", ^{
            
            NSNumber *parameters = @101;
            
            context(@"with a POST request", ^{
                
                it(@"should set the correct body and Content-Type header and retain the remaining headers", ^{
                    request.HTTPMethod = @"POST";
                });
            });
            
            context(@"with a PUT request", ^{
                
                it(@"should set the correct body and Content-Type header and retain the remaining headers", ^{
                    request.HTTPMethod = @"PUT";
                });
            });
            
            afterEach(^{
                NSURLRequest *modifiedRequest = [[MMStringRequestSerializer serializer] requestBySerializingRequest:request withParameters:parameters error:NULL];
                [[modifiedRequest.URL.absoluteString should] equal:@"http://magnet.com"];
                [[modifiedRequest.HTTPBody should] equal:[[parameters stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
                [[modifiedRequest.allHTTPHeaderFields[@"Content-Type"] should] equal:@"text/plain; charset=utf-8"];
                [[modifiedRequest.allHTTPHeaderFields[@"X-Foo"] should] equal:@"Bar"];
            });
        });
    });
});

SPEC_END
