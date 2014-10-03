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

#import "MMControllerMethod_Private.h"

@implementation MMControllerMethod

#pragma mark - Overriden getters

- (MMControllerReturnType)returnTypeEnum {
    /*
     Taken from AttributeType.java
     STRING("_string"),
     ENUM("_enum"),
     BOOLEAN("_boolean"),
     BYTE("_byte"),
     CHAR("_char"),
     SHORT("_short"),
     INTEGER("_integer"),
     LONG("_long"),
     FLOAT("_float"),
     DOUBLE("_double"),
     BIG_DECIMAL("_big_decimal"),
     BIG_INTEGER("_big_integer"),
     DATE("_date"),
     URI("_uri"),
     MAGNET_URI("magnet-uri"),
     LIST("_list"),
     DATA("_data"),
     BYTES("_bytes"),
     REFERENCE("_reference"),
     MAGNET_NODE("_node"),
     MAGNET_PROJECTION("_projection"),
     OBJECT("_object");
     */
    MMControllerReturnType controllerReturnType = MMControllerReturnTypeVoid;
    if ([self.returnType isEqualToString:@"_string"]) {
        controllerReturnType = MMControllerReturnTypeString;
    } else if ([self.returnType hasPrefix:@"_enum:"]) {
        controllerReturnType = MMControllerReturnTypeEnum;
    } else if ([self.returnType isEqualToString:@"_boolean"]) {
        controllerReturnType = MMControllerReturnTypeBoolean;
    } else if ([self.returnType isEqualToString:@"_byte"]) {
        controllerReturnType = MMControllerReturnTypeByte;
    } else if ([self.returnType isEqualToString:@"_char"]) {
        controllerReturnType = MMControllerReturnTypeChar;
    } else if ([self.returnType isEqualToString:@"_short"]) {
        controllerReturnType = MMControllerReturnTypeShort;
    } else if ([self.returnType isEqualToString:@"_integer"]) {
        controllerReturnType = MMControllerReturnTypeInteger;
    } else if ([self.returnType isEqualToString:@"_long"]) {
        controllerReturnType = MMControllerReturnTypeLong;
    } else if ([self.returnType isEqualToString:@"_float"]) {
        controllerReturnType = MMControllerReturnTypeFloat;
    } else if ([self.returnType isEqualToString:@"_double"]) {
        controllerReturnType = MMControllerReturnTypeDouble;
    } else if ([self.returnType isEqualToString:@"_big_decimal"]) {
        controllerReturnType = MMControllerReturnTypeBigDecimal;
    } else if ([self.returnType isEqualToString:@"_big_integer"]) {
        controllerReturnType = MMControllerReturnTypeBigInteger;
    } else if ([self.returnType isEqualToString:@"_date"]) {
        controllerReturnType = MMControllerReturnTypeDate;
    } else if ([self.returnType isEqualToString:@"_uri"]) {
        controllerReturnType = MMControllerReturnTypeUri;
    } else if ([self.returnType hasPrefix:@"_list:"]) {
        controllerReturnType = MMControllerReturnTypeList;
    } else if ([self.returnType isEqualToString:@"_data"]) {
        controllerReturnType = MMControllerReturnTypeData;
    } else if ([self.returnType isEqualToString:@"_bytes"]) {
        controllerReturnType = MMControllerReturnTypeBytes;
    } else if ([self.returnType hasPrefix:@"_reference"]) {
        controllerReturnType = MMControllerReturnTypeReference;
    } else if ([self.returnType isEqualToString:@"_node"] || [self.returnType hasPrefix:@"_bean"]) {
        controllerReturnType = MMControllerReturnTypeMagnetNode;
    }

    return controllerReturnType;
}

- (BOOL)returnsString {
    BOOL returnsString = NO;

    switch (self.returnTypeEnum) {
        case MMControllerReturnTypeVoid:
        case MMControllerReturnTypeString:
        case MMControllerReturnTypeBoolean:
        case MMControllerReturnTypeByte:
        case MMControllerReturnTypeChar:
        case MMControllerReturnTypeShort:
        case MMControllerReturnTypeInteger:
        case MMControllerReturnTypeLong:
        case MMControllerReturnTypeFloat:
        case MMControllerReturnTypeDouble:
        case MMControllerReturnTypeBigDecimal:
        case MMControllerReturnTypeBigInteger:
        case MMControllerReturnTypeDate:
        case MMControllerReturnTypeUri:
        case MMControllerReturnTypeBytes:
        case MMControllerReturnTypeEnum:
        {
            returnsString = YES;
            break;
        }
        case MMControllerReturnTypeData:{
            break;
        }
        case MMControllerReturnTypeList:{
            break;
        }
        case MMControllerReturnTypeReference:{
            // FIXME: hardcoded
            returnsString = YES;
            break;
        }
        case MMControllerReturnTypeMagnetNode:{
            break;
        }
    }

    return returnsString;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToMethod:other];
}

- (BOOL)isEqualToMethod:(MMControllerMethod *)method {
    if (self == method)
        return YES;
    if (method == nil)
        return NO;
    if (self.method != method.method && ![self.method isEqualToString:method.method])
        return NO;
    if (self.name != method.name && ![self.name isEqualToString:method.name])
        return NO;
    if (self.parameters != method.parameters && ![self.parameters isEqualToArray:method.parameters])
        return NO;
    if (self.path != method.path && ![self.path isEqualToString:method.path])
        return NO;
    if (self.returnType != method.returnType && ![self.returnType isEqualToString:method.returnType])
        return NO;
    if (self.produces != method.produces && ![self.produces isEqualToSet:method.produces])
        return NO;
    if (self.consumes != method.consumes && ![self.consumes isEqualToSet:method.consumes])
        return NO;
    return !(self.baseURL != method.baseURL && ![self.baseURL isEqual:method.baseURL]);
}

- (NSUInteger)hash {
    NSUInteger hash = [self.method hash];
    hash = hash * 31u + [self.name hash];
    hash = hash * 31u + [self.parameters hash];
    hash = hash * 31u + [self.path hash];
    hash = hash * 31u + [self.returnType hash];
    hash = hash * 31u + [self.produces hash];
    hash = hash * 31u + [self.consumes hash];
    hash = hash * 31u + [self.baseURL hash];
    return hash;
}

#pragma mark - NSObject

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.method=%@", self.method];
    [description appendFormat:@", self.name=%@", self.name];
    [description appendFormat:@", self.parameters=%@", self.parameters];
    [description appendFormat:@", self.path=%@", self.path];
    [description appendFormat:@", self.returnType=%@", self.returnType];
    [description appendFormat:@", self.produces=%@", self.produces];
    [description appendFormat:@", self.consumes=%@", self.consumes];
    [description appendFormat:@", self.baseURL=%@", self.baseURL];
    [description appendString:@">"];
    return description;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    MMControllerMethod *copy = (MMControllerMethod *) [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.method = self.method;
        copy.name = self.name;
        copy.parameters = self.parameters;
        copy.path = self.path;
        copy.returnType = self.returnType;
        copy.produces = self.produces;
        copy.consumes = self.consumes;
        copy.baseURL = self.baseURL;
    }

    return copy;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.method = [coder decodeObjectForKey:@"self.method"];
        self.name = [coder decodeObjectForKey:@"self.name"];
        self.parameters = [coder decodeObjectForKey:@"self.parameters"];
        self.path = [coder decodeObjectForKey:@"self.path"];
        self.returnType = [coder decodeObjectForKey:@"self.returnType"];
        self.produces = [coder decodeObjectForKey:@"self.produces"];
        self.consumes = [coder decodeObjectForKey:@"self.consumes"];
        self.baseURL = [coder decodeObjectForKey:@"self.baseURL"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.method forKey:@"self.method"];
    [coder encodeObject:self.name forKey:@"self.name"];
    [coder encodeObject:self.parameters forKey:@"self.parameters"];
    [coder encodeObject:self.path forKey:@"self.path"];
    [coder encodeObject:self.returnType forKey:@"self.returnType"];
    [coder encodeObject:self.produces forKey:@"self.produces"];
    [coder encodeObject:self.consumes forKey:@"self.consumes"];
    [coder encodeObject:self.baseURL forKey:@"self.baseURL"];
}

@end
