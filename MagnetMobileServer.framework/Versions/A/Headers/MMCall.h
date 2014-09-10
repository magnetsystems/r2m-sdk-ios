/**
 * Copyright (c) 2012-2014 Magnet Systems, Inc. All rights reserved.
 */
 
/**
 * This interface represents an asynchronous invocation to a controller.  An
 * instance of the object is typically returned by a method call from any
 * MMController implementation.
 *
 */
@interface MMCall : NSOperation

/**
 * A system-generated unique ID for this call.
 */
@property(nonatomic, readonly) NSString *callId;

@end
