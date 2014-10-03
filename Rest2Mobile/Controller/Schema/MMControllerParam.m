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
 
#import "MMControllerParam_Private.h"
#import "MMResourceNode.h"

@implementation MMControllerParam

- (MMControllerInputType)inputTypeEnum {
    MMControllerInputType inputTypeEnum = MMControllerInputTypeString;

    // Get @"MMTNodeWithAllTypes" from @"MMTNodeWithAllTypes *"
    // A lot of classes like NSString * would pass this check, but a check for node is towards the end of the switch.
    // We can add an additonal check for classes not starting with NS, but then we are assuming that none of the developer classes start with NS (which is most likely true).
    Class clazz;
    if ([self.type hasSuffix:@" *"]) {
        clazz = NSClassFromString([self.type substringToIndex:(self.type.length - 2)]);
    }

    if ([self.type isEqualToString:@"NSString *"]) {
        inputTypeEnum = MMControllerInputTypeString;
    } else if ([self.type hasPrefix:@"_enum:"]) {
        inputTypeEnum = MMControllerInputTypeEnum;
    } else if ([self.type isEqualToString:@"BOOL"]) {
        inputTypeEnum = MMControllerInputTypeBoolean;
    } else if ([self.type isEqualToString:@"char"]) {
        inputTypeEnum = MMControllerInputTypeByte;
    } else if ([self.type isEqualToString:@"unichar"]) {
        inputTypeEnum = MMControllerInputTypeChar;
    } else if ([self.type isEqualToString:@"short"]) {
        inputTypeEnum = MMControllerInputTypeShort;
    } else if ([self.type isEqualToString:@"int"]) {
        inputTypeEnum = MMControllerInputTypeInteger;
    } else if ([self.type isEqualToString:@"long long"]) {
        inputTypeEnum = MMControllerInputTypeLong;
    } else if ([self.type isEqualToString:@"float"]) {
        inputTypeEnum = MMControllerInputTypeFloat;
    } else if ([self.type isEqualToString:@"double"]) {
        inputTypeEnum = MMControllerInputTypeDouble;
    } else if ([self.type isEqualToString:@"NSDecimalNumber *"]) {
        inputTypeEnum = MMControllerInputTypeBigDecimal;
    } else if ([self.type isEqualToString:@"java.math.BigInteger"]) {
        inputTypeEnum = MMControllerInputTypeBigInteger;
    } else if ([self.type isEqualToString:@"NSDate *"]) {
        inputTypeEnum = MMControllerInputTypeDate;
    } else if ([self.type isEqualToString:@"NSURL *"]) {
        inputTypeEnum = MMControllerInputTypeUri;
    } else if ([self.type hasPrefix:@"_list:"]) {
        inputTypeEnum = MMControllerInputTypeList;
    } else if ([self.type isEqualToString:@"MMData *"]) {
        inputTypeEnum = MMControllerInputTypeData;
    } else if ([self.type isEqualToString:@"NSData *"]) {
        inputTypeEnum = MMControllerInputTypeBytes;
    } else if ([self.type hasPrefix:@"_reference"]) {
        inputTypeEnum = MMControllerInputTypeReference;
    } else if ([clazz isSubclassOfClass:MMResourceNode.class]) {
        inputTypeEnum = MMControllerInputTypeMagnetNode;
    }

    return inputTypeEnum;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToParam:other];
}

- (BOOL)isEqualToParam:(MMControllerParam *)param {
    if (self == param)
        return YES;
    if (param == nil)
        return NO;
    if (self.name != param.name && ![self.name isEqualToString:param.name])
        return NO;
    if (self.optional != param.optional && ![self.optional isEqualToNumber:param.optional])
        return NO;
    if (self.style != param.style && ![self.style isEqualToString:param.style])
        return NO;
    return !(self.type != param.type && ![self.type isEqualToString:param.type]);
}

- (NSUInteger)hash {
    NSUInteger hash = [self.name hash];
    hash = hash * 31u + [self.optional hash];
    hash = hash * 31u + [self.style hash];
    hash = hash * 31u + [self.type hash];
    return hash;
}

#pragma mark - NSObject

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.name=%@", self.name];
    [description appendFormat:@", self.optional=%@", self.optional];
    [description appendFormat:@", self.style=%@", self.style];
    [description appendFormat:@", self.type=%@", self.type];
    [description appendString:@">"];
    return description;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    MMControllerParam *copy = (MMControllerParam *) [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.name = self.name;
        copy.optional = self.optional;
        copy.style = self.style;
        copy.type = self.type;
    }

    return copy;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectForKey:@"self.name"];
        self.optional = [coder decodeObjectForKey:@"self.optional"];
        self.style = [coder decodeObjectForKey:@"self.style"];
        self.type = [coder decodeObjectForKey:@"self.type"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"self.name"];
    [coder encodeObject:self.optional forKey:@"self.optional"];
    [coder encodeObject:self.style forKey:@"self.style"];
    [coder encodeObject:self.type forKey:@"self.type"];
}


@end
