/**
 * Copyright (c) 2012-2014 Magnet Systems, Inc. All rights reserved.
 */
 
#import <Mantle/Mantle.h>

@interface MMResourceNode : MTLModel

/** The node type. */

+ (NSDictionary *)attributeMappings;

+ (NSDictionary *)listAttributeTypes;

+ (NSDictionary *)referenceAttributeTypes;
@end
