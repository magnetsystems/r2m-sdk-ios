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
 `MMControllerParam` represents a specific input parameter like a QUERY/HEADER parameter that should be passed as a part of the HTTP request.
 Instances of this class are typically created automatically in `MMController:metaData` implementation.
 */

@interface MMControllerParam : NSObject <NSCopying, NSCoding>

/**
 The name of the parameter.
 */
@property(nonatomic, copy) NSString *name;

/**
 A boolean value to indicate if the parameter is optional.
 */
@property(nonatomic, strong) NSNumber *optional;

/**
 The style of the parameter. Examples: QUERY/FORM/HEADER.
 */
@property(nonatomic, copy) NSString *style;

/**
 The type of the parameter. It could be one of the supported primitives or a `MMResourceNode` object.
 */
@property(nonatomic, copy) NSString *type;

/**
Returns a Boolean value that indicates whether a given parameter is equal to the receiver using a comparison of the parameter properties.

@param param The parameter with which to compare the receiver.

@return YES if parameter is equivalent to the receiver (if they have the same id or if their properties are equal), otherwise NO.
*/
- (BOOL)isEqualToParam:(MMControllerParam *)param;

@end
