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

#import <Kiwi/Kiwi.h>
#import "MMResourceNode_Private.h"
#import "TESTNodeWithAllTypes.h"
#import "MMValueTransformer.h"

SPEC_BEGIN(MMResourceNodeSpec)

describe(@"MMResourceNode", ^{
    
    context(@"when calling dictionaryValue", ^{
        
        TESTNodeWithAllTypes *testNode = [[TESTNodeWithAllTypes alloc] init];
        testNode.stringAttribute = @"Hello Magnet";
        it(@"should not contain null values", ^{
            [[[[testNode dictionaryValue] allValues] shouldNot] contain:NSNull.null];
        });
    });
    
    context(@"when calling attributeMappings", ^{
        
        it(@"should return nil", ^{
            [[[MMResourceNode attributeMappings] should] beNil];
        });
    });
    
    context(@"when calling listAttributeTypes", ^{
        
        it(@"should return nil", ^{
            [[[MMResourceNode listAttributeTypes] should] beNil];
        });
    });
    
    context(@"when calling referenceAttributeTypes", ^{
        
        it(@"should return nil", ^{
            [[[MMResourceNode referenceAttributeTypes] should] beNil];
        });
    });
    
    context(@"when calling JSONKeyPathsByPropertyKey", ^{
        
        it(@"should return nil", ^{
            [[[MMResourceNode JSONKeyPathsByPropertyKey] should] beNil];
        });
    });
    
    context(@"when calling classForParsingJSONDictionary", ^{
        
        it(@"should return the class", ^{
            [[[MMResourceNode classForParsingJSONDictionary:nil] should] beSubclassOfClass:MMResourceNode.class];
        });
    });
    
    context(@"when calling JSONTransformerForKey:", ^{
        
        it(@"should return the correct value transformer", ^{
            NSValueTransformer *transformer = [MMValueTransformer unicharTransformer];
            [MMValueTransformer stub:@selector(unicharTransformer) andReturn:transformer];
            [[MMValueTransformer should] receive:@selector(unicharTransformer) withCount:1 arguments:nil];
            [TESTNodeWithAllTypes JSONTransformerForKey:@"charAttribute"];
            
            transformer = [MMValueTransformer floatTransformer];
            [MMValueTransformer stub:@selector(floatTransformer) andReturn:transformer];
            [[MMValueTransformer should] receive:@selector(floatTransformer) withCount:1 arguments:nil];
            [TESTNodeWithAllTypes JSONTransformerForKey:@"floatAttribute"];
            
            transformer = [MMValueTransformer doubleTransformer];
            [MMValueTransformer stub:@selector(doubleTransformer) andReturn:transformer];
            [[MMValueTransformer should] receive:@selector(doubleTransformer) withCount:1 arguments:nil];
            [TESTNodeWithAllTypes JSONTransformerForKey:@"doubleAttribute"];
            
            transformer = [MMValueTransformer longLongTransformer];
            [MMValueTransformer stub:@selector(longLongTransformer) andReturn:transformer];
            [[MMValueTransformer should] receive:@selector(longLongTransformer) withCount:1 arguments:nil];
            [TESTNodeWithAllTypes JSONTransformerForKey:@"longAttribute"];
            
            transformer = [MMValueTransformer enumTransformerForKey:@"enumAttribute"];
            [MMValueTransformer stub:@selector(enumTransformerForKey:) andReturn:transformer];
            [[MMValueTransformer should] receive:@selector(enumTransformerForKey:) withCount:1 arguments:@"enumAttribute"];
            [TESTNodeWithAllTypes JSONTransformerForKey:@"enumAttribute"];
            
            transformer = [MMValueTransformer dateTransformer];
            [MMValueTransformer stub:@selector(dateTransformer) andReturn:transformer];
            [[MMValueTransformer should] receive:@selector(dateTransformer) withCount:1 arguments:@"dateAttribute"];
            [TESTNodeWithAllTypes JSONTransformerForKey:@"dateAttribute"];
            
            transformer = [MMValueTransformer urlTransformer];
            [MMValueTransformer stub:@selector(urlTransformer) andReturn:transformer];
            [[MMValueTransformer should] receive:@selector(urlTransformer) withCount:1 arguments:@"uriAttribute"];
            [TESTNodeWithAllTypes JSONTransformerForKey:@"uriAttribute"];
            
            transformer = [MMValueTransformer dataTransformer];
            [MMValueTransformer stub:@selector(dataTransformer) andReturn:transformer];
            [[MMValueTransformer should] receive:@selector(dataTransformer) withCount:1 arguments:@"bytesAttribute"];
            [TESTNodeWithAllTypes JSONTransformerForKey:@"bytesAttribute"];
            
            // TODO: Add test for resourceNodeTransformerForClass:
            
            transformer = [MMValueTransformer listTransformerForType:@"_string"];
            [MMValueTransformer stub:@selector(listTransformerForType:) andReturn:transformer];
            [[MMValueTransformer should] receive:@selector(listTransformerForType:) withCount:1 arguments:@"_string"];
            [TESTNodeWithAllTypes JSONTransformerForKey:@"listOfStringsAttribute"];
            
            transformer = [MMValueTransformer bigDecimalTransformer];
            [MMValueTransformer stub:@selector(bigDecimalTransformer) andReturn:transformer];
            [[MMValueTransformer should] receive:@selector(bigDecimalTransformer) withCount:1 arguments:nil];
            [TESTNodeWithAllTypes JSONTransformerForKey:@"bigDecimalAttribute"];
            
            transformer = [MMValueTransformer valueObjTransformerForType:@"_boolean"];
            [MMValueTransformer stub:@selector(valueObjTransformerForType:) andReturn:transformer];
            [[MMValueTransformer should] receive:@selector(valueObjTransformerForType:) withCount:1 arguments:@"_boolean"];
            [TESTNodeWithAllTypes JSONTransformerForKey:@"booleanReferenceAttribute"];
        });
    });
});
SPEC_END
