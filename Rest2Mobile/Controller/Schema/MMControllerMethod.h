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

/**
 `MMControllerMethod` represents a specific endpoint like GET /users that is accessible over REST.
 It contains complete metadata about the endpoint such as what goes in the headers vs body.
 Instances of this class are typically created automatically in `MMController:metaData` implementation.
 */

@interface MMControllerMethod : NSObject <NSCopying, NSCoding>

/**
 The HTTP method: GET/POST/PUT/DELETE.
 */
@property(nonatomic, copy) NSString *method;

/**
 First part of the selector name for a `MMController` method.
 */
@property(nonatomic, copy) NSString *name;

/**
 A collection of `MMControllerParam` objects.
 */
@property(nonatomic, copy) NSArray *parameters;

/**
 The HTTP path that is appended to the endpoint URL.
 */
@property(nonatomic, copy) NSString *path;

/**
 The return type of the success block of a `MMController` method. It could be one of the supported primitives, a `MMResourceNode` object or void.
 */
@property(nonatomic, copy) NSString *returnType;

/**
 The HTTP response Content-Type header.
 */
@property(nonatomic, copy) NSSet *produces;

/**
 The HTTP request Accept header.
 */
@property(nonatomic, copy) NSSet *consumes;

/**
 The base URL for the API service.
 */
@property(nonatomic, strong) NSURL *baseURL;

/**
Returns a Boolean value that indicates whether a given method is equal to the receiver using a comparison of the method properties.

@param method The method with which to compare the receiver.

@return YES if method is equivalent to the receiver (if they have the same id or if their properties are equal), otherwise NO.
*/
- (BOOL)isEqualToMethod:(MMControllerMethod *)method;

@end