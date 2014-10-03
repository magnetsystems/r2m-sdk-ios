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

#import <Rest2Mobile/Rest2Mobile.h>

typedef NS_ENUM(NSUInteger, EnumAttribute){
    EnumAttributeSTARTED = 0,
    EnumAttributeINPROGRESS,
    EnumAttributeENDED,
};

@interface EnumAttributeContainer : NSObject

+ (NSDictionary *)mappings;

@end


@interface TESTNodeWithAllTypes : MMResourceNode

//field declarations
/** A BigDecimal attribute */
@property (nonatomic, strong) NSDecimalNumber *bigDecimalAttribute;

/** A BigInteger attribute */
@property (nonatomic, strong) NSDecimalNumber *bigIntegerAttribute;

/** A boolean attribute */
@property (nonatomic, assign) BOOL booleanAttribute;

/** A Boolean attribute */
@property (nonatomic, assign) BOOL booleanWrapperAttribute;

/**  */
@property (nonatomic, strong) NSValue *booleanReferenceAttribute;

/** A byte attribute */
@property (nonatomic, assign) char byteAttribute;

/** A bytes attribute */
@property (nonatomic, strong) NSData *bytesAttribute;

/** A Byte attribute */
@property (nonatomic, assign) char byteWrapperAttribute;

/** A char attribute */
@property (nonatomic, assign) unichar charAttribute;

/** A Character attribute */
@property (nonatomic, assign) unichar charWrapperAttribute;

/** A Date attribute */
@property (nonatomic, strong) NSDate *dateAttribute;

/** A double attribute */
@property (nonatomic, assign) double doubleAttribute;

/** A Double attribute */
@property (nonatomic, assign) double doubleWrapperAttribute;

/** An enum attribute */
@property (nonatomic, assign) EnumAttribute enumAttribute;

/** A float attribute */
@property (nonatomic, assign) float floatAttribute;

/** A Float attribute */
@property (nonatomic, assign) float floatWrapperAttribute;

/** An int attribute */
@property (nonatomic, assign) int integerAttribute;

/** An Integer attribute */
@property (nonatomic, assign) int integerWrapperAttribute;

/** A long attribute */
@property (nonatomic, assign) long long longAttribute;

/** A Long attribute */
@property (nonatomic, assign) long long longWrapperAttribute;

/** A short attribute */
@property (nonatomic, assign) short shortAttribute;

/** A Short attribute */
@property (nonatomic, assign) short shortWrapperAttribute;

/** A string attribute */
@property (nonatomic, copy) NSString *stringAttribute;

/**  */
@property (nonatomic, strong) NSValue *stringReferenceAttribute;

/** A URI attribute */
@property (nonatomic, strong) NSURL *uriAttribute;

/** A List of Strings attribute */
@property (nonatomic, strong) NSArray *listOfStringsAttribute;

/** A List of Shorts attribute */
@property (nonatomic, strong) NSArray *listOfShortsAttribute;

@end