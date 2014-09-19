/**
 * Copyright (c) 2012-2014 Magnet Systems, Inc. All rights reserved.
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
@property(nonatomic, readonly) NSString *callId;

@end
