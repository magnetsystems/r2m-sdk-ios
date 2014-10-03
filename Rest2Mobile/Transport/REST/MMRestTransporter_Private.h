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

#import "MMRestTransporter.h"
#import "MMRestApiCall.h"
#import "MMControllerParam_Private.h"
#import "MMHTTPRequestOperationManager.h"

@interface MMRestTransporter()

@property (nonatomic, strong) NSMutableDictionary *managers;

- (NSString *)basePathForControllerMethod:(MMControllerMethod *)controllerMethod
                               invocation:(NSInvocation *)invocation;

- (NSString *)removeLeadingSlash:(NSString *)basePath;

- (MMRestApiCall *)extractRequestParametersForInvocation:(NSInvocation *)anInvocation
                                        controllerMethod:(MMControllerMethod *)controllerMethod;

- (id)transformParameter:(MMControllerParam *)parameter
              invocation:(NSInvocation *)anInvocation
                 atIndex:(int)index;

- (void)executeSuccessBlock:(id)successBlock
         platformReturnType:(NSString *)platformReturnType
       controllerReturnType:(MMControllerReturnType)returnTypeEnumValue
             responseObject:(id)responseObject
              responseClass:(Class)responseClass;

- (NSString *)matrixParameterWithName:(NSString *)name
                                value:(__unsafe_unretained id)value;

- (id)safeCopy:(id)argument;

- (MMHTTPRequestOperationManager *)managerWithConfiguration:(MMControllerConfiguration *)controllerConfiguration;

@end
