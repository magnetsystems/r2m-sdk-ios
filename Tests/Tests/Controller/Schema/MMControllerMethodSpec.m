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
#import "MMControllerMethod_Private.h"
#import "GOOGLEDistanceController.h"

SPEC_BEGIN(MMControllerMethodSpec)

describe(@"MMControllerMethod", ^{
    
    context(@"when calling returnTypeEnum", ^{
        
        it(@"should return the correct enum value", ^{
            MMControllerMethod *controllerMethod = [[MMControllerMethod alloc] init];
            controllerMethod.returnType = @"_string";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeString)];
            controllerMethod.returnType = @"_enum:SomeEnum";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeEnum)];
            controllerMethod.returnType = @"_boolean";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeBoolean)];
            controllerMethod.returnType = @"_byte";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeByte)];
            controllerMethod.returnType = @"_char";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeChar)];
            controllerMethod.returnType = @"_short";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeShort)];
            controllerMethod.returnType = @"_integer";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeInteger)];
            controllerMethod.returnType = @"_long";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeLong)];
            controllerMethod.returnType = @"_float";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeFloat)];
            controllerMethod.returnType = @"_double";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeDouble)];
            controllerMethod.returnType = @"_big_decimal";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeBigDecimal)];
            controllerMethod.returnType = @"_big_integer";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeBigInteger)];
            controllerMethod.returnType = @"_date";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeDate)];
            controllerMethod.returnType = @"_uri";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeUri)];
            controllerMethod.returnType = @"_list:_string";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeList)];
            controllerMethod.returnType = @"_data";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeData)];
            controllerMethod.returnType = @"_bytes";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeBytes)];
            controllerMethod.returnType = @"_reference";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeReference)];
            controllerMethod.returnType = @"_node";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeMagnetNode)];
            controllerMethod.returnType = @"_bean";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeMagnetNode)];
            controllerMethod.returnType = @"void";
            [[theValue(controllerMethod.returnTypeEnum) should] equal:theValue(MMControllerReturnTypeVoid)];
            
        });
    });
    
    context(@"when calling returnsString", ^{
        
        it(@"should return the correct value", ^{
            MMControllerMethod *controllerMethod = [[MMControllerMethod alloc] init];
            controllerMethod.returnType = @"_string";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_enum:SomeEnum";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_boolean";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_byte";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_char";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_short";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_integer";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_long";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_float";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_double";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_big_decimal";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_big_integer";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_date";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_uri";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_list:_string";
            [[theValue(controllerMethod.returnsString) should] beNo];
            controllerMethod.returnType = @"_data";
            [[theValue(controllerMethod.returnsString) should] beNo];
            controllerMethod.returnType = @"_bytes";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_reference";
            [[theValue(controllerMethod.returnsString) should] beYes];
            controllerMethod.returnType = @"_node";
            [[theValue(controllerMethod.returnsString) should] beNo];
            controllerMethod.returnType = @"_bean";
            [[theValue(controllerMethod.returnsString) should] beNo];
            controllerMethod.returnType = @"void";
            [[theValue(controllerMethod.returnsString) should] beYes];
            
        });
    });
    
    context(@"when calling isEqualToMethod:", ^{
        
        MMControllerMethod *controllerMethod = [GOOGLEDistanceController metaData][@"GOOGLEDistanceController:getDistance"];
        __block MMControllerMethod *otherControllerMethod;
        
        beforeEach(^{
            otherControllerMethod = [controllerMethod copy];
        });
        
        context(@"when methods are one and the same object", ^{
            it(@"should return YES", ^{
                [[theValue([controllerMethod isEqualToMethod:controllerMethod]) should] beYes];
            });
        });
        
        context(@"when method is nil", ^{
            it(@"should return NO", ^{
                [[theValue([controllerMethod isEqualToMethod:nil]) should] beNo];
            });
        });
        
        context(@"when method is different", ^{
            it(@"should return NO", ^{
                otherControllerMethod.method = @"POST";
                [[theValue([controllerMethod isEqualToMethod:otherControllerMethod]) should] beNo];
            });
        });
        
        context(@"when name is different", ^{
            it(@"should return NO", ^{
                otherControllerMethod.name = @"postDistance";
                [[theValue([controllerMethod isEqualToMethod:otherControllerMethod]) should] beNo];
            });
        });
        
        context(@"when parameters are different", ^{
            it(@"should return NO", ^{
                otherControllerMethod.parameters = [[controllerMethod.parameters reverseObjectEnumerator] allObjects];
                [[theValue([controllerMethod isEqualToMethod:otherControllerMethod]) should] beNo];
            });
        });
        
        context(@"when path is different", ^{
            it(@"should return NO", ^{
                otherControllerMethod.path = @"distancematrix/json";
                [[theValue([controllerMethod isEqualToMethod:otherControllerMethod]) should] beNo];
            });
        });
        
        context(@"when returnType is different", ^{
            it(@"should return NO", ^{
                otherControllerMethod.returnType = @"_bean:DistanceResult";
                [[theValue([controllerMethod isEqualToMethod:otherControllerMethod]) should] beNo];
            });
        });
        
        context(@"when produces is different", ^{
            it(@"should return NO", ^{
                otherControllerMethod.produces = [NSSet setWithObjects:@"application/xml", nil];
                [[theValue([controllerMethod isEqualToMethod:otherControllerMethod]) should] beNo];
            });
        });
        
        context(@"when consumes is different", ^{
            it(@"should return NO", ^{
                otherControllerMethod.consumes = [NSSet setWithObjects:@"application/xml", nil];
                [[theValue([controllerMethod isEqualToMethod:otherControllerMethod]) should] beNo];
            });
        });
        
        context(@"when baseURL is different", ^{
            it(@"should return NO", ^{
                otherControllerMethod.baseURL = [NSURL URLWithString:@"https://magnet.com"];
                [[theValue([controllerMethod isEqualToMethod:otherControllerMethod]) should] beNo];
            });
        });
    });
    
    context(@"when calling copyWithZone:", ^{
        
        it(@"should correctly copy the values", ^{
            MMControllerMethod *controllerMethod = [GOOGLEDistanceController metaData][@"GOOGLEDistanceController:getDistance"];
            
            MMControllerMethod *otherControllerMethod = [controllerMethod copy];
            
            [[controllerMethod.method should] equal:otherControllerMethod.method];
            [[controllerMethod.name should] equal:otherControllerMethod.name];
            [[controllerMethod.parameters should] equal:otherControllerMethod.parameters];
            [[controllerMethod.path should] equal:otherControllerMethod.path];
            [[controllerMethod.returnType should] equal:otherControllerMethod.returnType];
            [[controllerMethod.produces should] equal:otherControllerMethod.produces];
            [[controllerMethod.consumes should] beNil];
            [[otherControllerMethod.consumes should] beNil];
            [[controllerMethod.baseURL should] equal:otherControllerMethod.baseURL];
        });
    });
    
    context(@"when calling initWithCoder: / encodeWithCoder:", ^{
        
        it(@"should decode / encode", ^{
            MMControllerMethod *controllerMethod = [GOOGLEDistanceController metaData][@"GOOGLEDistanceController:getDistance"];
            NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:controllerMethod];
            [[[NSKeyedUnarchiver unarchiveObjectWithData:archive] should] equal:controllerMethod];
        });
    });
});

SPEC_END
