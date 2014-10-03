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
 
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class MMRestApiCall;

/**
 `MMHTTPRequestOperationManager` is a subclass of AFNetworking's `AFHTTPRequestOperationManager` which encapsulates the common patterns of communicating with a web application over HTTP, including request creation, response serialization, network reachability monitoring, and security, as well as request operation management.
 */

@interface MMHTTPRequestOperationManager : AFHTTPRequestOperationManager

/**
 The URL used to monitor reachability, and construct requests from relative paths in methods like `requestWithMethod:URLString:parameters:`, and the `GET` / `POST` / et al. convenience methods.
 */
@property (readwrite, nonatomic, strong) NSURL *baseURL;

/**
 Returns a `AFHTTPRequestOperation` instance based on the REST API call and the success/failure blocks.
 
 @param restApiCall The REST API call that represents a specific endpoint.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 
 @return AFHTTPRequestOperation that represents the controller invocation.
 */
- (AFHTTPRequestOperation *)HTTPRequestOperationWithRestApiCall:(MMRestApiCall *)restApiCall
                                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
