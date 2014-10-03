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

@class MMControllerMethod;
@class AFHTTPRequestOperation;
@class MMRestTransporter;
@class MMControllerConfiguration;

/**
 `MMTransporter` abstracts all implementation details of the transport for a `MMController`.
 Today, only REST controllers are supported, but more transports would be supported in the future.
 */

@interface MMTransporter : NSObject

/**
 Creates and returns an `MMTransporter` object.
 */
+ (instancetype)transporter;

/**
 Retrieves the shared transporter instance.
 */
+ (instancetype)sharedTransporter;

/**
 Returns a `AFHTTPRequestOperation` instance based on the metadata, invocation and the configuration.
 
 @param controllerMethod The controller method that represents a specific endpoint.
 @param invocation The current invocation for the controller.
 @param controllerConfiguration The configuration for the controller.
 
 @return AFHTTPRequestOperation that represents the controller invocation.
 */
- (AFHTTPRequestOperation *)HTTPRequestOperationWithControllerMethod:(MMControllerMethod *)controllerMethod
                                                          invocation:(NSInvocation *)invocation
                                             controllerConfiguration:(MMControllerConfiguration *)controllerConfiguration;

@end
