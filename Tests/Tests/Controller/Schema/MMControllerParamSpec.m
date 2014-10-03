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
#import "MMControllerParam_Private.h"
#import "GOOGLEDistance.h"
#import "GOOGLEDistanceController.h"

SPEC_BEGIN(MMControllerParamSpec)

describe(@"MMControllerParam", ^{
    
    context(@"when calling inputTypeEnum", ^{
        
        it(@"should return the correct enum value", ^{
            MMControllerParam *controllerParam = [[MMControllerParam alloc] init];
            controllerParam.type = @"NSString *";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeString)];
            controllerParam.type = @"_enum:SomeEnum";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeEnum)];
            controllerParam.type = @"BOOL";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeBoolean)];
            controllerParam.type = @"char";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeByte)];
            controllerParam.type = @"unichar";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeChar)];
            controllerParam.type = @"short";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeShort)];
            controllerParam.type = @"int";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeInteger)];
            controllerParam.type = @"long long";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeLong)];
            controllerParam.type = @"float";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeFloat)];
            controllerParam.type = @"double";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeDouble)];
            controllerParam.type = @"NSDecimalNumber *";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeBigDecimal)];
            controllerParam.type = @"java.math.BigInteger";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeBigInteger)];
            controllerParam.type = @"NSDate *";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeDate)];
            controllerParam.type = @"NSURL *";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeUri)];
            controllerParam.type = @"_list:_string";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeList)];
            controllerParam.type = @"MMData *";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeData)];
            controllerParam.type = @"NSData *";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeBytes)];
            controllerParam.type = @"_reference";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeReference)];
            controllerParam.type = @"GOOGLEDistance *";
            [[theValue(controllerParam.inputTypeEnum) should] equal:theValue(MMControllerInputTypeMagnetNode)];
        });
    });
    
    MMControllerMethod *controllerMethod = [GOOGLEDistanceController metaData][@"GOOGLEDistanceController:getDistance"];
    MMControllerParam *param = controllerMethod.parameters[0];
    
    context(@"when calling isEqualToMethod:", ^{
        
        __block MMControllerParam *otherParam;
        
        beforeEach(^{
            otherParam = [param copy];
        });
        
        context(@"when params are one and the same object", ^{
            it(@"should return YES", ^{
                [[theValue([param isEqualToParam:param]) should] beYes];
            });
        });
        
        context(@"when param is nil", ^{
            it(@"should return NO", ^{
                [[theValue([param isEqualToParam:nil]) should] beNo];
            });
        });
        
        context(@"when name is different", ^{
            it(@"should return NO", ^{
                param.name = @"destinations";
                [[theValue([param isEqualToParam:otherParam]) should] beNo];
            });
        });
        
        context(@"when optional is different", ^{
            it(@"should return NO", ^{
                param.optional = @NO;
                [[theValue([param isEqualToParam:otherParam]) should] beNo];
            });
        });
        
        context(@"when style is different", ^{
            it(@"should return NO", ^{
                otherParam.style = @"HEADER";
                [[theValue([param isEqualToParam:otherParam]) should] beNo];
            });
        });
        
        context(@"when type is different", ^{
            it(@"should return NO", ^{
                otherParam.type = @"NSNumber *";
                [[theValue([param isEqualToParam:otherParam]) should] beNo];
            });
        });
    });
    
    context(@"when calling copyWithZone:", ^{
        
        __block MMControllerParam *otherParam;
        
        beforeEach(^{
            otherParam = [param copy];
        });
        
        it(@"should correctly copy the values", ^{
            
            [[param.name should] equal:otherParam.name];
            [[param.optional should] equal:otherParam.optional];
            [[param.style should] equal:otherParam.style];
            [[param.type should] equal:otherParam.type];
        });
    });
    
    context(@"when calling initWithCoder: / encodeWithCoder:", ^{
        
        it(@"should decode / encode", ^{
            NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:param];
            [[[NSKeyedUnarchiver unarchiveObjectWithData:archive] should] equal:param];
        });
    });
});

SPEC_END
