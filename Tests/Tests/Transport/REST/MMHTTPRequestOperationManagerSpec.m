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
#import "MMHTTPRequestOperationManager.h"
#import "MMRestApiCall.h"
#import "GOOGLEDistance.h"

SPEC_BEGIN(MMHTTPRequestOperationManagerSpec)

describe(@"MMHTTPRequestOperationManager", ^{
    
    context(@"when calling initWithBaseURL:", ^{
        
        context(@"with nil URL", ^{
        
            it(@"should set the URL to localhost", ^{
                MMHTTPRequestOperationManager *manager = [[MMHTTPRequestOperationManager alloc] initWithBaseURL:nil];
                [[manager.baseURL.absoluteString should] equal:@"http://localhost:8080/rest/"];
            });
        });
        
        context(@"with empty URL", ^{
            
            it(@"should set the URL to localhost", ^{
                MMHTTPRequestOperationManager *manager = [[MMHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
                [[manager.baseURL.absoluteString should] equal:@"http://localhost:8080/rest/"];
            });
        });
        
        context(@"with valid URL", ^{
            
            it(@"should set the correct URL", ^{
                MMHTTPRequestOperationManager *manager = [[MMHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://magnet.com"]];
                [[manager.baseURL.absoluteString should] equal:@"http://magnet.com"];
                [[manager.requestSerializer should] beMemberOfClass:AFHTTPRequestSerializer.class];
                [[manager.responseSerializer should] beMemberOfClass:AFHTTPResponseSerializer.class];
            });
        });
    });
    
    context(@"when calling HTTPRequestOperationWithRestApiCall:success:failure:", ^{
        
        context(@"with a POST body of type FORM encoded", ^{
            
            it(@"should return the correct FORM encoded body", ^{
                MMRestApiCall *restApiCall = [MMRestApiCall restApiCall];
                restApiCall.isFormUrlEncoded = YES;
                restApiCall.bodyParameters = @{ @"name" : @"John Appleseed", @"email" : @"john.appleseed@magnet.com" };
                restApiCall.basePath = @"/userInfo";
                restApiCall.httpMethod = MMRequestMethodPOST;
                MMHTTPRequestOperationManager *manager = [[MMHTTPRequestOperationManager alloc] initWithBaseURL:nil];
                manager.securityPolicy.allowInvalidCertificates = YES;
                
                AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRestApiCall:restApiCall success:nil failure:nil];
                NSString *HTTPBody = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
                NSArray *HTTPBodyParts = [HTTPBody componentsSeparatedByString:@"&"];
                for (NSString *formParameter in HTTPBodyParts) {
                    NSArray *formParameterParts = [formParameter componentsSeparatedByString:@"="];
                    NSString *percentEscapedExpectedValue = MMPercentEscapedQueryStringValueFromStringWithEncoding(restApiCall.bodyParameters[formParameterParts[0]], NSUTF8StringEncoding);
                    [[percentEscapedExpectedValue should] equal:formParameterParts[1]];
                }
                
                // Other assertions
                [[theValue(operation.securityPolicy.allowInvalidCertificates) should] beYes];
                [[operation.completionQueue should] equal:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
            });
        });
        
        context(@"with a GET with query parameters", ^{
            
            it(@"should return the correct request", ^{
                MMRestApiCall *restApiCall = [MMRestApiCall restApiCall];
                restApiCall.queryParameters = @{ @"name" : @"John Appleseed", @"email" : @"john.appleseed@magnet.com" };
                restApiCall.basePath = @"/userInfo";
                restApiCall.httpMethod = MMRequestMethodGET;
                MMHTTPRequestOperationManager *manager = [[MMHTTPRequestOperationManager alloc] initWithBaseURL:nil];
                
                AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRestApiCall:restApiCall success:nil failure:nil];
                NSArray *HTTPBodyParts = [operation.request.URL.query componentsSeparatedByString:@"&"];
                for (NSString *queryParameter in HTTPBodyParts) {
                    NSArray *queryParameterParts = [queryParameter componentsSeparatedByString:@"="];
                    NSString *percentEscapedExpectedValue = MMPercentEscapedQueryStringValueFromStringWithEncoding(restApiCall.queryParameters[queryParameterParts[0]], NSUTF8StringEncoding);
                    [[percentEscapedExpectedValue should] equal:queryParameterParts[1]];
                }
            });
        });
        
        context(@"with a POST body of type JSON", ^{
            
            context(@"with multiple parameters", ^{
            
                it(@"should return the correct JSON body", ^{
                    MMRestApiCall *restApiCall = [MMRestApiCall restApiCall];
                    restApiCall.isFormUrlEncoded = NO;
                    restApiCall.bodyParameters = @{ @"name" : @"John Appleseed", @"email" : @"john.appleseed@magnet.com" };
                    restApiCall.basePath = @"/userInfo";
                    restApiCall.httpMethod = MMRequestMethodPOST;
                    MMHTTPRequestOperationManager *manager = [[MMHTTPRequestOperationManager alloc] initWithBaseURL:nil];
                    manager.securityPolicy.allowInvalidCertificates = YES;
                    
                    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRestApiCall:restApiCall success:nil failure:nil];
                    
                    NSDictionary *requestBody = [NSJSONSerialization JSONObjectWithData:operation.request.HTTPBody options:0 error:NULL];
                    
                    [[restApiCall.bodyParameters should] equal:requestBody];
                });
            });
            
            context(@"with one parameter of type JSON (dictionary)", ^{
                
                it(@"should flatten the payload", ^{
                    MMRestApiCall *restApiCall = [MMRestApiCall restApiCall];
                    restApiCall.isFormUrlEncoded = NO;
                    restApiCall.bodyParameters = @{ @"profile" : @{ @"name" : @"John Appleseed", @"email" : @"john.appleseed@magnet.com" }};
                    restApiCall.basePath = @"/userInfo";
                    restApiCall.httpMethod = MMRequestMethodPOST;
                    MMHTTPRequestOperationManager *manager = [[MMHTTPRequestOperationManager alloc] initWithBaseURL:nil];
                    manager.securityPolicy.allowInvalidCertificates = YES;
                    
                    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRestApiCall:restApiCall success:nil failure:nil];
                    
                    NSDictionary *requestBody = [NSJSONSerialization JSONObjectWithData:operation.request.HTTPBody options:0 error:NULL];
                    
                    [[restApiCall.bodyParameters[@"profile"] should] equal:requestBody];
                });
            });
            
            context(@"with one parameter of type JSON (array)", ^{
                
                it(@"should flatten the payload", ^{
                    MMRestApiCall *restApiCall = [MMRestApiCall restApiCall];
                    restApiCall.isFormUrlEncoded = NO;
                    restApiCall.bodyParameters = @{ @"fruits" : @[ @"apples", @"oranges" ]};
                    restApiCall.basePath = @"/userInfo";
                    restApiCall.httpMethod = MMRequestMethodPOST;
                    MMHTTPRequestOperationManager *manager = [[MMHTTPRequestOperationManager alloc] initWithBaseURL:nil];
                    manager.securityPolicy.allowInvalidCertificates = YES;
                    
                    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRestApiCall:restApiCall success:nil failure:nil];
                    
                    NSArray *requestBody = [NSJSONSerialization JSONObjectWithData:operation.request.HTTPBody options:0 error:NULL];
                    
                    [[restApiCall.bodyParameters[@"fruits"] should] equal:requestBody];
                });
            });
            
            context(@"with one parameter of type STRING", ^{
                
                it(@"should flatten the payload", ^{
                    MMRestApiCall *restApiCall = [MMRestApiCall restApiCall];
                    restApiCall.isFormUrlEncoded = NO;
                    restApiCall.bodyParameters = @{ @"profile" : @"John Appleseed"};
                    restApiCall.basePath = @"/userInfo";
                    restApiCall.httpMethod = MMRequestMethodPOST;
                    MMHTTPRequestOperationManager *manager = [[MMHTTPRequestOperationManager alloc] initWithBaseURL:nil];
                    manager.securityPolicy.allowInvalidCertificates = YES;
                    
                    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRestApiCall:restApiCall success:nil failure:nil];
                    
                    NSString *HTTPBody = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
                    
                    [[restApiCall.bodyParameters[@"profile"] should] equal:HTTPBody];
                });
            });
            
            context(@"with one parameter of type magnet-node (bean)", ^{
                
                it(@"should flatten the payload", ^{
                    MMRestApiCall *restApiCall = [MMRestApiCall restApiCall];
                    restApiCall.isFormUrlEncoded = NO;
                    GOOGLEDistance *distance = [[GOOGLEDistance alloc] init];
                    distance.text = @"435 Tasso St";
                    distance.value = 101;
                    restApiCall.bodyParameters = @{ @"profile" : distance};
                    restApiCall.basePath = @"/userInfo";
                    restApiCall.httpMethod = MMRequestMethodPOST;
                    MMHTTPRequestOperationManager *manager = [[MMHTTPRequestOperationManager alloc] initWithBaseURL:nil];
                    manager.securityPolicy.allowInvalidCertificates = YES;
                    
                    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRestApiCall:restApiCall success:nil failure:nil];
                    
                    NSDictionary *requestBody = [NSJSONSerialization JSONObjectWithData:operation.request.HTTPBody options:0 error:NULL];
                    
                    [[distance.text should] equal:requestBody[@"text"]];
                    [[theValue(distance.value) should] equal:requestBody[@"value"]];
                });
            });
        });
    });
});

SPEC_END
