/**
 * Copyright (c) 2012-2014 Magnet Systems, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 `MMControllerParam` represents a specific input parameter like a QUERY/HEADER parameter that should be passed as a part of the HTTP request.
 Instances of this class are typically created automatically in `MMController:metaData` implementation.
 */
 
@interface MMControllerParam : NSObject

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

@end
