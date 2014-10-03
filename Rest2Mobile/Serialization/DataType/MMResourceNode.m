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
 
#import "MMResourceNode_Private.h"
#import "MMValueTransformer.h"
#import <objc/runtime.h>

@implementation MMResourceNode

#pragma mark - MTLModel

// Removes all nil objects from the dictionary
// http://stackoverflow.com/questions/18961622/how-to-omit-null-values-in-json-dictionary-using-mantle
- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *modifiedDictionaryValue = [[super dictionaryValue] mutableCopy];

    for (NSString *originalKey in [super dictionaryValue]) {
        if ([self valueForKey:originalKey] == nil) {
            [modifiedDictionaryValue removeObjectForKey:originalKey];
        }
    }

    return [modifiedDictionaryValue copy];
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)attributeMappings {
    return nil;
}

+ (NSDictionary *)listAttributeTypes {
    return nil;
}

+ (NSDictionary *)referenceAttributeTypes {
    return nil;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [self attributeMappings];
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    return self;
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    NSString *typeAttribute = [self propertyTypeAttributeForKey:key];
    NSString *propertyType = [typeAttribute substringFromIndex:1];
    const char *rawPropertyType = [propertyType UTF8String];

    if (strcmp(rawPropertyType, @encode(unichar)) == 0) {
        return [MMValueTransformer unicharTransformer];
    } else if (strcmp(rawPropertyType, @encode(float)) == 0) {
        return [MMValueTransformer floatTransformer];
    } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
        return [MMValueTransformer doubleTransformer];
    } else if (strcmp(rawPropertyType, @encode(long long)) == 0) {
        return [MMValueTransformer longLongTransformer];
    } else if (strcmp(rawPropertyType, @encode(NSUInteger)) == 0) { // Enum case
        return [MMValueTransformer enumTransformerForKey:key];
    } else if ([typeAttribute hasPrefix:@"T@"]) {
        Class clazz = [self classFromPropertyType:typeAttribute];
        return [self transformerForClass:clazz key:key];
    }

    return nil;
}

#pragma mark - Private implementation

+ (NSValueTransformer *)transformerForClass:(Class)clazz
                                        key:(NSString *)key {
    if ([clazz isSubclassOfClass:[NSDate class]]) {
        return [MMValueTransformer dateTransformer];
    } else if ([clazz isSubclassOfClass:[NSURL class]]) {
        return [MMValueTransformer urlTransformer];
    } else if ([clazz isSubclassOfClass:[NSData class]]) {
        return [MMValueTransformer dataTransformer];
    } else if ([clazz isSubclassOfClass:[MMResourceNode class]]) {
        return [MMValueTransformer resourceNodeTransformerForClass:clazz];
    } else if ([clazz isSubclassOfClass:[NSArray class]]) {
        return [MMValueTransformer listTransformerForType:[self listAttributeTypes][key]];
    } else if ([clazz isSubclassOfClass:[NSDecimalNumber class]]) {
        return [MMValueTransformer bigDecimalTransformer];
    } else if ([self referenceAttributeTypes][key] && [clazz isSubclassOfClass:[NSValue class]]) {
        return [MMValueTransformer valueObjTransformerForType:[self referenceAttributeTypes][key]];
    }
    return nil;
}

+ (Class)classFromPropertyType:(NSString *)propertyType {
    NSString * typeClassName = [propertyType substringWithRange:NSMakeRange(3, [propertyType length] - 4)];  //turns @"NSDate" into NSDate
    Class typeClass = NSClassFromString(typeClassName);
    return typeClass;
}

+ (NSString *)propertyTypeAttributeForKey:(NSString *)key {
    const char *keyAsChar = [key UTF8String];
    const char *propertyAttributesAsChar = property_getAttributes(class_getProperty([self class], keyAsChar));
    NSString *propertyAttributesString = [NSString stringWithUTF8String:propertyAttributesAsChar];
    NSArray *propertyAttributes = [propertyAttributesString componentsSeparatedByString:@","];
    NSString *propertyTypeAttribute = propertyAttributes[0];
    return propertyTypeAttribute;
}


@end
