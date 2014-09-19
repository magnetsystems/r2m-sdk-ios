/**
 * Copyright (c) 2012-2014 Magnet Systems, Inc. All rights reserved.
 */
 
#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

/**
 `MMResourceNode` represents a data object that is marshallable over REST.
 Instances of this class are used as an input parameter or the return value for `MMController` methods.

 ## Subclassing Notes
 
 Currently, `MMResourceNode` subclasses are auto-generated by the rest2mobile plugin for Xcode found here: https://github.com/magnetsystems/r2m-plugin-ios
 Subclasses can also auto-generated by the rest2mobile Command-line Tool found here: https://github.com/magnetsystems/r2m-cli
 
 ## Methods to Override
 
 Subclasses can optionally override `attributeMappings`. The dictionary returned by this method specifies how your model object's properties map to the keys in the JSON representation.
 Subclasses can also optionally override `listAttributeTypes`. The dictionary returned by this method specifies the type of objects contained in your model object's collection properties.
 */

@interface MMResourceNode : MTLModel

/**
 This method specifies how your model object's properties map to the keys in the JSON representation.
 
 @return A collection of object property to JSON representation mappings. This method can return nil if object property names have a 1-1 mapping with the JSON representation.
 */
+ (NSDictionary *)attributeMappings;

/**
 This method specifies the type of objects contained in your model object's collection properties.
 
 @return A collection of object property to type of contained object mappings. This method can return nil if there are no collection properties in the `MMResourceNode` instance.
 */
+ (NSDictionary *)listAttributeTypes;

@end
