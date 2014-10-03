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
 These constants indicate the input parameter type for the controller.
 */

typedef NS_ENUM(NSUInteger, MMControllerInputType){
    /**
     A string input parameter type.
     */
    MMControllerInputTypeString = 0,
    /**
     An enum input parameter type.
     */
    MMControllerInputTypeEnum,
    /**
     A boolean input parameter type.
     */
    MMControllerInputTypeBoolean,
    /**
     A byte input parameter type.
     */
    MMControllerInputTypeByte,
    /**
     A character input parameter type.
     */
    MMControllerInputTypeChar,
    /**
     A short input parameter type.
     */
    MMControllerInputTypeShort,
    /**
     An integer input parameter type.
     */
    MMControllerInputTypeInteger,
    /**
     A long input parameter type.
     */
    MMControllerInputTypeLong,
    /**
     A float input parameter type.
     */
    MMControllerInputTypeFloat,
    /**
     A double input parameter type.
     */
    MMControllerInputTypeDouble,
    /**
     A big decimal input parameter type.
     */
    MMControllerInputTypeBigDecimal,
    /**
     A big integer input parameter type.
     */
    MMControllerInputTypeBigInteger,
    /**
     A date input parameter type.
     */
    MMControllerInputTypeDate,
    /**
     A URI input parameter type.
     */
    MMControllerInputTypeUri,
    /**
     A list input parameter type.
     */
    MMControllerInputTypeList,
    /**
     A data input parameter type.
     */
    MMControllerInputTypeData,
    /**
     A sequence of bytes input parameter type.
     */
    MMControllerInputTypeBytes,
    /**
     A reference input parameter type.
     */
    MMControllerInputTypeReference,
    /**
     A magnet node (bean) input parameter type.
     */
    MMControllerInputTypeMagnetNode,
};
