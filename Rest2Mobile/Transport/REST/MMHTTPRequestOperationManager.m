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
 
#import <Mantle/Mantle.h>
#import "MMRestApiCall.h"
#import "MMHTTPRequestOperationManager.h"
#import "MMResourceNode.h"
#import "NSDictionary+MMUtilities.h"
#import "MMStringRequestSerializer.h"
#import "MMLogger.h"
#import "MMAssert.h"

typedef enum {
    HTTPContentTypeFORM,
    HTTPContentTypeJSON,
    HTTPContentTypeString,
} HTTPContentType;

@interface MMHTTPRequestOperationManager ()

- (NSURL *)endPointURL;

- (HTTPContentType)contentTypeForObject:(id)object;
@end

@implementation MMHTTPRequestOperationManager

@synthesize baseURL = _baseURL;

- (instancetype)initWithBaseURL:(NSURL *)url {
    [[MMLogger sharedLogger] debug:@"Initializing API client"];
    
    NSURL *baseURL = url && ![[url absoluteString] isEqualToString:@""] ? url : [self endPointURL];
    
    [[MMLogger sharedLogger] info:@"Controller configuration URL = %@", baseURL];
    
    self = [super initWithBaseURL:baseURL];
    
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    [[MMLogger sharedLogger] debug:@"Initialized API client"];
    
    return self;
}


- (NSURL *)endPointURL {
    NSString *URL = @"http://localhost:8080/rest";
    return [NSURL URLWithString:URL];
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRestApiCall:(MMRestApiCall *)restApiCall
                                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    id bodyParameters = restApiCall.bodyParameters;

    HTTPContentType httpContentType;
    if (restApiCall.isFormUrlEncoded) {
        httpContentType = HTTPContentTypeFORM;
    } else {
        // FIXME: Temporary hack because of https://magneteng.atlassian.net/browse/WON-5884
        if ([restApiCall.bodyParameters count] == 1) {
            
            [[MMLogger sharedLogger] verbose:@"Found one body parameter"];
            
            id firstObject = [restApiCall.bodyParameters firstObject];
            httpContentType = [self contentTypeForObject:firstObject];
            if (httpContentType == HTTPContentTypeJSON) {
                if ([firstObject isKindOfClass:[MMResourceNode class]]) {
                    bodyParameters = [MTLJSONAdapter JSONDictionaryFromModel:firstObject];
                } else {
                    bodyParameters = firstObject;
                }
            } else {
                bodyParameters = firstObject;
            }
        } else {
            httpContentType = HTTPContentTypeJSON;
        }
    }

    [[MMLogger sharedLogger] verbose:@"Content-Type = %i", httpContentType];
    
    // Handle query parameters
    NSString *URLString = [[self.baseURL absoluteString] stringByAppendingString:restApiCall.basePath];
    if ([restApiCall.queryParameters count] > 0) {

        [[MMLogger sharedLogger] verbose:@"Processing query string(s) for a NON-GET request"];

        NSError *error;
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:MMStringFromRequestMethod(MMRequestMethodGET) URLString:URLString parameters:restApiCall.queryParameters error:&error];

        if (error) {
            [[MMLogger sharedLogger] error:@"Error processing query string = %@", error];
        }

        URLString = [request.URL absoluteString];
    }

    // Handle body parameters

    AFHTTPRequestSerializer *requestSerializer;
    switch (httpContentType) {
        case HTTPContentTypeFORM:{
            requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        case HTTPContentTypeJSON:{
            requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
        case HTTPContentTypeString:{
            requestSerializer = [MMStringRequestSerializer serializer];
            break;
        }
    }

    [[MMLogger sharedLogger] verbose:@"request serializer = %@", requestSerializer];

    NSError *error;
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:MMStringFromRequestMethod(restApiCall.httpMethod)
                                                              URLString:URLString
                                                             parameters:bodyParameters
                                                                  error:&error];

    MMAssert(error == nil, @"Error creating request");

//    if (error) {
//        if (failure) {
//            failure(nil, error);
//        }
//        return nil;
//    }
    
    // Add headers
    [restApiCall.headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];

    AFHTTPRequestOperation *op = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    op.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    op.securityPolicy = self.securityPolicy;
    return op;
}

#pragma mark - Private implementation

- (HTTPContentType)contentTypeForObject:(id)object {
    HTTPContentType httpContentType;
    if ([object isKindOfClass:[MMResourceNode class]] || [object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
        httpContentType = HTTPContentTypeJSON;
    } else {
        httpContentType = HTTPContentTypeString;
    }
    return httpContentType;
}

@end
