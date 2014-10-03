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
 
#import <Foundation/Foundation.h>
#include <objc/runtime.h>
#include <stdint.h>
#include <stdio.h>
#import "MMLogger.h"

#if !defined(MM_BLOCK_ASSERTIONS)
# define MM_BLOCK_ASSERTIONS 0
#endif

#if !MM_BLOCK_ASSERTIONS

# define MMAssert(expression, ...) \
    do {\
        if (!(expression)) {	\
                NSString *description = [NSString stringWithFormat:@"" __VA_ARGS__]; \
                NSString *reason = [NSString \
                    stringWithFormat: @"Assertion failed with expression (%s) in %@:%i %s. %@", \
                    #expression, \
                    [[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
                    __LINE__, \
                    __PRETTY_FUNCTION__, \
                    description]; \
                [[MMLogger sharedLogger] error:@"%@", reason]; \
                [[NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil] raise]; \
                abort(); \
        } \
    } while(0)

# define MMParameterAssert(condition) MMAssert((condition), @"Invalid parameter not satisfying: %s", #condition)

#else
# define MMAssert(condition, desc, ...)
# define MMParameterAssert(condition) 
#endif
