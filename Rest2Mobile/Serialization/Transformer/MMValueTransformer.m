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
 
#import <Mantle/Mantle.h>
#import "MMValueTransformer.h"
#import "MMResourceNode.h"
#import "MMAssert.h"

static NSSet *MMPrimitiveTypes() {
    NSSet *primitiveTypes = [NSSet setWithObjects:@"_integer", @"_boolean", @"_byte",
                                                  @"_char", @"_short", @"_long", @"_float", @"_double", nil];
    return primitiveTypes;
}

@interface MMValueTransformer ()
+ (NSDateFormatter *)dateFormatter;
@end

@implementation MMValueTransformer

+ (instancetype)dateTransformer {
    // Cast to id is required to suppress the warning
    id transformer = [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[self dateFormatter] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[self dateFormatter] stringFromDate:date];
    }];
    return transformer;
}

+ (instancetype)urlTransformer {
    return (MMValueTransformer *) [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (instancetype)dataTransformer {
    // Cast to id is required to suppress the warning
    id transformer = [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[NSData alloc] initWithBase64EncodedString:str options:(NSDataBase64DecodingOptions) kNilOptions];
    } reverseBlock:^(NSData *value) {
        return [value base64EncodedStringWithOptions:(NSDataBase64EncodingOptions) kNilOptions];
    }];
    return transformer;
}

+ (instancetype)unicharTransformer {
    // Cast to id is required to suppress the warning
    id transformer = [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        unichar val = 0;
        if (str.length > 0) {
            val = [str characterAtIndex:0];
        }
        return @(val);
    } reverseBlock:^(NSNumber *value) {
        return [NSString stringWithFormat:@"%C", [value unsignedShortValue]];
    }];
    return transformer;
}

+ (instancetype)floatTransformer {
    // Cast to id is required to suppress the warning
    id transformer = [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *jsonValue) {
        return [NSString stringWithFormat:@"%f", [jsonValue floatValue]];
    } reverseBlock:^(NSNumber *value) {
        return [NSString stringWithFormat:@"%f", [value floatValue]];
    }];
    return transformer;
}

+ (instancetype)doubleTransformer {
    // Cast to id is required to suppress the warning
    id transformer = [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *jsonValue) {
        return [NSString stringWithFormat:@"%f", [jsonValue doubleValue]];
    } reverseBlock:^(NSNumber *value) {
        return [NSString stringWithFormat:@"%f", [value doubleValue]];
    }];
    return transformer;
}

+ (instancetype)longLongTransformer {
    // Cast to id is required to suppress the warning
    id transformer = [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *jsonValue) {
        long long longLongNumber = [[jsonValue description] longLongValue];
        return [NSString stringWithFormat:@"%lli", longLongNumber];
    } reverseBlock:^(NSNumber *value) {
        long long longLongNumber = [[value description] longLongValue];
        return [NSString stringWithFormat:@"%lli", longLongNumber];
    }];
    return transformer;
}

+ (instancetype)booleanTransformer {
    return (MMValueTransformer *) [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (instancetype)enumTransformerForKey:(NSString *)key {
    // Capitalize: enumAttribute should become EnumAttribute
    NSString *firstChar = [key substringToIndex:1];
    NSString *capitalizedKey = [[firstChar uppercaseString] stringByAppendingString:[key substringFromIndex:1]];
    NSString *enumAttributeContainer = [capitalizedKey stringByAppendingString:@"Container"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSDictionary *mappings = [NSClassFromString(enumAttributeContainer) performSelector:@selector(mappings)];
#pragma clang diagnostic pop    
    return (MMValueTransformer *) [NSValueTransformer mtl_valueMappingTransformerWithDictionary:mappings];
}

+ (instancetype)resourceNodeTransformerForClass:(Class)clazz {

    return (MMValueTransformer *) [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:clazz];
}

+ (instancetype)listTransformerForType:(NSString *)type {
    // Cast to id is required to suppress the warning
    id transformer = [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSArray *values) {
        NSMutableArray *mutableArray;
        if (values) {
            mutableArray = [NSMutableArray arrayWithCapacity:values.count];
        }
        for (id obj in values) {
            id objectToAdd = obj;
            MMValueTransformer *valueTransformer = [self transformerForType:type];
            if (valueTransformer) {
                objectToAdd = [[self transformerForType:type] transformedValue:obj];
            }
            [mutableArray addObject:objectToAdd];
        }

        return [mutableArray copy];
    } reverseBlock:^(NSArray *values) {
        NSMutableArray *mutableArray;
        if (values) {
            mutableArray = [NSMutableArray arrayWithCapacity:values.count];
        }
        for (id obj in values) {
            id objectToAdd = obj;
            MMValueTransformer *valueTransformer = [self transformerForType:type];
            if (valueTransformer) {
                objectToAdd = [valueTransformer reverseTransformedValue:obj];
            }
            [mutableArray addObject:objectToAdd];
        }
        return [mutableArray copy];
    }];
    return transformer;
}

+ (instancetype)bigDecimalTransformer {
    // Cast to id is required to suppress the warning
    id transformer = [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *jsonValue) {
        return [NSDecimalNumber decimalNumberWithString:jsonValue];
    } reverseBlock:^(NSDecimalNumber *value) {
        return [value stringValue];
    }];
    return transformer;
}

+ (instancetype)valueObjTransformerForType:(NSString *)type {
    id transformer = [MTLValueTransformer reversibleTransformerWithForwardBlock:^(id jsonValue) {
        NSValue *returnValue;
        if (!jsonValue) {
            returnValue = [NSValue valueWithNonretainedObject:[NSNull null]];
        } else {
            if ([type isEqualToString:@"_integer"]) {
                int param1 = [jsonValue intValue];
                returnValue = [NSValue value:&param1 withObjCType:@encode(int)];
            } else if ([type isEqualToString:@"_boolean"]) {
                BOOL param1;
                if ([jsonValue isKindOfClass:[NSString class]]) {
                    if ([jsonValue isEqualToString:@"true"]) {
                        param1 =  YES;
                    } else if ([jsonValue isEqualToString:@"false"]) {
                        param1 = NO;
                    }
                } else if ([jsonValue isKindOfClass:[NSNumber class]]) {
                    param1 = [jsonValue boolValue];
                }
                returnValue = [NSValue value:&param1 withObjCType:@encode(BOOL)];
            } else if ([type isEqualToString:@"_byte"]) {
                char param1 = [jsonValue charValue];
                returnValue = [NSValue value:&param1 withObjCType:@encode(char)];
            } else if ([type isEqualToString:@"_char"]) {
                unichar param1 = [jsonValue unsignedShortValue];
                returnValue = [NSValue value:&param1 withObjCType:@encode(unichar)];
            } else if ([type isEqualToString:@"_short"]) {
                short param1 = [jsonValue shortValue];
                returnValue = [NSValue value:&param1 withObjCType:@encode(short)];
            } else if ([type isEqualToString:@"_long"]) {
                long long param1 = [[jsonValue description] longLongValue];
                returnValue = [NSValue value:&param1 withObjCType:@encode(long long)];
            } else if ([type isEqualToString:@"_float"]) {
                float param1 = [jsonValue floatValue];
                returnValue = [NSValue value:&param1 withObjCType:@encode(float)];
            } else if ([type isEqualToString:@"_double"]) {
                double param1 = [jsonValue doubleValue];
                returnValue = [NSValue value:&param1 withObjCType:@encode(double)];
            } else {
                MMValueTransformer *valueTransformer = [self transformerForType:type];
                if (valueTransformer) {
                    returnValue = [NSValue valueWithNonretainedObject:[valueTransformer transformedValue:jsonValue]];
                } else {
                    returnValue = [NSValue valueWithNonretainedObject:jsonValue];
                }
            }
        }
        return returnValue;
    } reverseBlock:^(NSValue *value) {
        id returnVal;

        if (value && strcmp([value objCType], @encode(void *)) == 0) {
            id containedValue;
            [value getValue:&containedValue];
            if ([[NSNull null] isEqual:containedValue]) {
                returnVal = [NSNull null];
            }
        }
        if (![[NSNull null] isEqual:returnVal]) {
            if (!value) {
                returnVal = nil;
            } else {
                if ([type isEqualToString:@"_integer"]) {
                    int returnValue;
                    [value getValue:&returnValue];
                    returnVal = @(returnValue);
                } else if ([type isEqualToString:@"_boolean"]) {
                    BOOL returnValue;
                    [value getValue:&returnValue];
                    returnVal = @(returnValue);
                } else if ([type isEqualToString:@"_byte"]) {
                    char returnValue;
                    [value getValue:&returnValue];
                    returnVal = @(returnValue);
                } else if ([type isEqualToString:@"_char"]) {
                    unichar returnValue;
                    [value getValue:&returnValue];
                    returnVal = @(returnValue);
                } else if ([type isEqualToString:@"_short"]) {
                    short returnValue;
                    [value getValue:&returnValue];
                    returnVal = @(returnValue);
                } else if ([type isEqualToString:@"_long"]) {
                    long long returnValue;
                    [value getValue:&returnValue];
                    returnVal = @(returnValue);
                } else if ([type isEqualToString:@"_float"]) {
                    float returnValue;
                    [value getValue:&returnValue];
                    returnVal = @(returnValue);
                } else if ([type isEqualToString:@"_double"]) {
                    double returnValue;
                    [value getValue:&returnValue];
                    returnVal = @(returnValue);
                } else {
                    id returnValue;
                    [value getValue:&returnValue];
                    returnVal = returnValue;
                    MMValueTransformer *valueTransformer = [self transformerForType:type];
                    if (valueTransformer) {
                        returnVal = [valueTransformer reverseTransformedValue:returnValue];
                    }
                }
            }
        }
        return returnVal;
    }];
    return transformer;
}

#pragma mark - Private implementation

+ (instancetype)transformerForType:(NSString *)type {
    
    MMValueTransformer *valueTransformer;
    if ([MMPrimitiveTypes() containsObject:type]) {
        valueTransformer = [MMValueTransformer valueObjTransformerForType:type];
    } else if ([type isEqualToString:@"_node"] || [type isEqualToString:@"_bean"]) {
        valueTransformer = [self resourceNodeTransformerForClass:[MMResourceNode class]];
    } else if ([type isEqualToString:@"_uri"]) {
        valueTransformer = [MMValueTransformer urlTransformer];
    } else if ([type isEqualToString:@"_date"]) {
        valueTransformer = [MMValueTransformer dateTransformer];
    } else if ([type isEqualToString:@"_big_decimal"] || [type isEqualToString:@"_big_integer"]) {
        valueTransformer = [MMValueTransformer bigDecimalTransformer];
    } else if ([type hasPrefix:@"_bean:"]) {
        MMAssert([[type componentsSeparatedByString:@":"] count] > 1, @"bean is invalid");
        valueTransformer = [self resourceNodeTransformerForClass:NSClassFromString([type componentsSeparatedByString:@":"][1])];
    }
    else {
        
    }
    
    return valueTransformer;
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *__dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __dateFormatter = [[NSDateFormatter alloc] init];
        __dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [__dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        __dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    });
    return __dateFormatter;
}

@end
