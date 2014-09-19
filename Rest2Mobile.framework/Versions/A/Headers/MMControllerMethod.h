/**
 * Copyright (c) 2012-2014 Magnet Systems, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 `MMControllerMethod` represents a specific endpoint like GET /users that is accessible over REST.
 It contains enough metadata to translate a `MMController` method invocation into a REST request.
 Instances of this class are typically created automatically in `MMController:metaData` implementation.
 */
 
@interface MMControllerMethod : NSObject

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

@end
