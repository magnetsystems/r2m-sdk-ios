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

#import "TESTNodeWithAllTypes.h"

@implementation EnumAttributeContainer

+ (NSDictionary *)mappings {
    return @{
             @"STARTED" : @(EnumAttributeSTARTED),
             @"INPROGRESS" : @(EnumAttributeINPROGRESS),
             @"ENDED" : @(EnumAttributeENDED),
             };
}

@end

@implementation TESTNodeWithAllTypes

+ (NSDictionary *)attributeMappings {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      }];
    [dictionary addEntriesFromDictionary:[super attributeMappings]];
    return [dictionary copy];
}

+ (NSDictionary *)listAttributeTypes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"listOfStringsAttribute" : @"_string",
                                                                                      @"listOfShortsAttribute" : @"_short",
                                                                                      }];
    [dictionary addEntriesFromDictionary:[super attributeMappings]];
    return [dictionary copy];
}

+ (NSDictionary *)referenceAttributeTypes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"booleanReferenceAttribute" : @"_boolean",
                                                                                      @"stringReferenceAttribute" : @"_string",
                                                                                      }];
    [dictionary addEntriesFromDictionary:[super attributeMappings]];
    return [dictionary copy];
}

@end
