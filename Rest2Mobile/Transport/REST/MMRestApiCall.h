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
#import "MMControllerReturnType.h"
#import "MMHTTPUtilities.h"
#import <Mantle/Mantle.h>
#import <AFNetworking/AFNetworking.h>

/**
 `MMRestApiCall` represents a specific invocation of an endpoint like GET /users that is accessible over REST.
 It captures data like query parameters, headers and body parameters to translate a `MMController` method invocation into a REST request.
 */

@interface MMRestApiCall : MTLModel

/**
 The basePath for the API call.
 */
@property (nonatomic, copy) NSString *basePath;

/**
 The query parameters for the API call.
 */
@property (nonatomic, copy) NSDictionary *queryParameters;

/**
 The body parameters for the API call. These could be be FORM encoded or JSON depending on `isFormUrlEncoded`.
 */
@property (nonatomic, copy) NSDictionary *bodyParameters;

/**
 The HTTP headers for the API call.
 */
@property (nonatomic, copy) NSDictionary *headers;

/**
 Whether the body is FORM encoded or not.
 */
@property (nonatomic, assign) BOOL isFormUrlEncoded;

/**
 The return type for the API call.
 */
@property(nonatomic, copy) NSString *returnType;

/**
 The return type enum for the API call.
 */
@property (nonatomic, assign) MMControllerReturnType returnTypeEnum;

/**
 Whether the API call returns a string.
 */
@property(nonatomic, assign) BOOL returnsString;

/**
 The HTTP method for the API call.
 */
@property (nonatomic, assign) MMRequestMethod httpMethod;

/**
 The success block for the API call.
 */
@property (nonatomic, copy) id success;

/**
 The failure block for the API call.
 */
@property (nonatomic, copy) void (^failure)(NSError *);

/**
 The response class for the API call. This is only used when the API call returns a magnet node (bean).
 */
@property(nonatomic, strong) Class responseClass;

/**
 Creates and returns an `MMRestApiCall` object.
 */
+ (instancetype)restApiCall;

/**
 Returns the response serializer for the API call. This is an instance of `MMStringResponseSerializer` for string responses and `AFJSONResponseSerializer` for JSON responses.
 */
- (AFHTTPResponseSerializer *)responseSerializer;

@end
