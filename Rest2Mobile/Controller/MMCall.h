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

/**
 `MMCall` is a subclass of `NSOperation` which represents an asynchronous invocation to a `MMController`.
 An instance of the object is typically returned by a method call in the `MMController` class.
 */

@interface MMCall : NSOperation

/**
 A system-generated unique UUID for this call.
 */
@property(nonatomic, readonly) NSUUID *callId;

@end
