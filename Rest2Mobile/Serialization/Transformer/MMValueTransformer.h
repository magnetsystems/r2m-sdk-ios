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
 `MMValueTransformer` is a subclass of `NSValueTransformer` with two responsibilities:
 
 - Converting strongly-typed input parameters to an object that can be sent over the wire.
 - Converting wire response to strongly-typed return object.
 
 Right now, the valid representations are JSON and String.
 */

@interface MMValueTransformer : NSValueTransformer

/**
 Creates a reversible transformer to convert a `NSDate` object into yyyy-MM-dd'T'HH:mm:ss'Z' in the UTC Time Zone, and vice-versa.
 
 @return Returns a reversible transformer
 */
+ (instancetype)dateTransformer;

/**
 Creates a reversible transformer to convert a `NSURL` object into a string, and vice-versa.
 
 @return Returns a reversible transformer
 */
+ (instancetype)urlTransformer;

/**
 Creates a reversible transformer to convert a `NSData` object into a base64 encoded string, and vice-versa.
 
 @return Returns a reversible transformer
 */
+ (instancetype)dataTransformer;

/**
 Creates a reversible transformer to convert a unichar into a string, and vice-versa.
 
 @return Returns a reversible transformer
 */
+ (instancetype)unicharTransformer;

/**
 Creates a reversible transformer to convert a float into a string, and vice-versa.
 
 @return Returns a reversible transformer
 */
+ (instancetype)floatTransformer;

/**
 Creates a reversible transformer to convert a double into a string, and vice-versa.
 
 @return Returns a reversible transformer
 */
+ (instancetype)doubleTransformer;

/**
 Creates a reversible transformer to convert a long long into a string, and vice-versa.
 
 @return Returns a reversible transformer
 */
+ (instancetype)longLongTransformer;

/**
 Creates a reversible transformer to convert a boolean into true/false, and vice-versa.
 
 @return Returns a reversible transformer
 */
+ (instancetype)booleanTransformer;

/**
 Creates a reversible transformer to convert an enum into a string based on the captured meta data, and vice-versa.
 
 @param key The name of the enum.
 
 @return Returns a reversible transformer
 */
+ (instancetype)enumTransformerForKey:(NSString *)key;

/**
 Creates a reversible transformer to convert a `MMResourceNode` object into a dictionary, and vice-versa.
 
 @param clazz The specific subclass of the resource node.
 
 @return Returns a reversible transformer
 */
+ (instancetype)resourceNodeTransformerForClass:(Class)clazz;

/**
 Creates a reversible transformer to convert a `NSArray` object into an `NSArray` object with the necessary transformation applied to each element, and vice-versa.
 
 @param type The type of the elements present in the list.
 
 @return Returns a reversible transformer
 */
+ (instancetype)listTransformerForType:(NSString *)type;

/**
 Creates a reversible transformer to convert a `NSDecimalNumber` object into a string, and vice-versa.
 
 @return Returns a reversible transformer
 */
+ (instancetype)bigDecimalTransformer;

/**
 Creates a reversible transformer to convert an object into a string/collection based on type, and vice-versa.
 
 @param type The type of the object to be transformed.
 
 @return Returns a reversible transformer
 */
+ (instancetype)valueObjTransformerForType:(NSString *)type;

@end
