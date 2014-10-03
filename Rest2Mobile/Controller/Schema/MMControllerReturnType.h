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

/**
 These constants indicate the controller return type.
 */

typedef NS_ENUM(NSUInteger, MMControllerReturnType){
    /**
     A void return type.
     */
    MMControllerReturnTypeVoid = 0,
    /**
     A string return type.
     */
    MMControllerReturnTypeString,
    /**
     An enum return type.
     */
    MMControllerReturnTypeEnum,
    /**
     A boolean return type.
     */
    MMControllerReturnTypeBoolean,
    /**
     A byte return type.
     */
    MMControllerReturnTypeByte,
    /**
     A character return type.
     */
    MMControllerReturnTypeChar,
    /**
     A short return type.
     */
    MMControllerReturnTypeShort,
    /**
     An integer return type.
     */
    MMControllerReturnTypeInteger,
    /**
     A long return type.
     */
    MMControllerReturnTypeLong,
    /**
     A float return type.
     */
    MMControllerReturnTypeFloat,
    /**
     A double return type.
     */
    MMControllerReturnTypeDouble,
    /**
     A big decimal return type.
     */
    MMControllerReturnTypeBigDecimal,
    /**
     A big integer return type.
     */
    MMControllerReturnTypeBigInteger,
    /**
     A date return type.
     */
    MMControllerReturnTypeDate,
    /**
     A URI return type.
     */
    MMControllerReturnTypeUri,
    /**
     A list return type.
     */
    MMControllerReturnTypeList,
    /**
     A data return type.
     */
    MMControllerReturnTypeData,
    /**
     A sequence of bytes return type.
     */
    MMControllerReturnTypeBytes,
    /**
     A reference return type.
     */
    MMControllerReturnTypeReference,
    /**
     A magnet node (bean) return type.
     */
    MMControllerReturnTypeMagnetNode,
};
