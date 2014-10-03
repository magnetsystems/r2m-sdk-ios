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
#import "MMStringResponseSerializer.h"

SPEC_BEGIN(MMStringResponseSerializerSpec)

describe(@"MMStringResponseSerializer", ^{

    context(@"when calling responseObjectForResponse:data:error:", ^{
        
        context(@"with invalid Content-Type", ^{
            
            it(@"should return nil", ^{
                NSDictionary *responseHeaders = @{ @"Content-Type" : @"text/html; charset=UTF-8" };
                NSURL *URL = [NSURL URLWithString:@"http://magnet.com"];
                NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL
                                                                          statusCode:200
                                                                         HTTPVersion:@"HTTP/1.1"
                                                                        headerFields:responseHeaders];
                
                NSError *error;
                id reponseObject = [[MMStringResponseSerializer serializer] responseObjectForResponse:response
                                                                                                 data:[@"Hello Magnet!" dataUsingEncoding:NSUTF8StringEncoding]
                                                                                                error:&error];
                [[reponseObject should] beNil];
                [[theValue(error.code) should] equal:theValue(NSURLErrorCannotDecodeContentData)];
                [[error.domain should] equal:AFURLResponseSerializationErrorDomain];
            });
        });
        
        context(@"with a valid Content-Type, but invalid status code", ^{
            
            it(@"should not return nil", ^{
                NSDictionary *responseHeaders = @{ @"Content-Type" : @"text/plain; charset=UTF-8" };
                NSURL *URL = [NSURL URLWithString:@"http://magnet.com"];
                NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL
                                                                          statusCode:404
                                                                         HTTPVersion:@"HTTP/1.1"
                                                                        headerFields:responseHeaders];
                
                NSError *error;
                id reponseObject = [[MMStringResponseSerializer serializer] responseObjectForResponse:response
                                                                                                 data:[@"Hello Magnet!" dataUsingEncoding:NSUTF8StringEncoding]
                                                                                                error:&error];
                [[reponseObject should] beNonNil];
                [[theValue(error.code) should] equal:theValue(NSURLErrorBadServerResponse)];
                [[error.domain should] equal:AFURLResponseSerializationErrorDomain];
            });
        });
        
        context(@"with a valid Content-Type", ^{
            
            it(@"should not return nil", ^{
                NSDictionary *responseHeaders = @{ @"Content-Type" : @"text/plain; charset=UTF-8" };
                NSURL *URL = [NSURL URLWithString:@"http://magnet.com"];
                NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL
                                                                          statusCode:200
                                                                         HTTPVersion:@"HTTP/1.1"
                                                                        headerFields:responseHeaders];
                
                NSError *error;
                id reponseObject = [[MMStringResponseSerializer serializer] responseObjectForResponse:response
                                                                                                 data:[@"Hello Magnet!" dataUsingEncoding:NSUTF8StringEncoding]
                                                                                                error:&error];
                [[reponseObject should] beNonNil];
                [[error should] beNil];
            });
        });
    });
});

SPEC_END
