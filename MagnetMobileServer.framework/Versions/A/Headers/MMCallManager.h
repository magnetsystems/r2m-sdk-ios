/**
 * Copyright (c) 2012-2014 Magnet Systems, Inc. All rights reserved.
 */
 
@class MMCall;

/**
 * This interface provides basic cache management, queue management,
 * and reliable calls management.  All methods in this interface are blocking
 * methods.
 */
@interface MMCallManager : NSObject

/**
 Retrieve the shared instance of the call manager.

 @return The shared call manager instance.
 */
+ (instancetype)sharedManager;

/**
 * Clear all cached results.
 */
- (void)clearCache;

/**
 * Cancel all pending reliable calls.
 */
- (void)cancelAllPendingCalls;

/**
 * Cancel all pending reliable calls in the specified queue.
 * @param queueName The queue name.
 */
- (void)cancelAllPendingCalls:(NSString *)queueName;

/**
 * Retrieve all pending reliable calls.
 * @return A collection of pending Call objects.
 */
- (NSArray *)allPendingCalls;

/**
 * Retrieve all pending reliable calls in the specified queue.  This is a blocking method.
 * @param queueName The queue name.
 * @return A collection of pending MMCall objects.
 */
- (NSArray *)allPendingCalls:(NSString *)queueName;

/**
 * Retrieve a MMCall instance by its unique ID.  This is for reliable calls
 * only. 
 * @param callId An MMCall unique ID.
 * @return An MMCall object, or `nil` if the unique ID is invalid, the call is timed out, or the asynchronous
 * call was "done".
 */
- (MMCall *)call:(NSString *)callId;

/**
 * Shortcut for calling cancelAllPendingCalls and clearCache
 */
- (void)reset;

/**
 * Triggers all non-empty thread queues to be awakened (if asleep) to
 * re-attempt processing.
 */
- (void)run;

/**
 * Dispose all completed calls.
 */
- (void)disposeAllDoneCallsWithBlock:(void (^)(NSUInteger numberOfDisposedCalls, NSError *error))block;

@end
