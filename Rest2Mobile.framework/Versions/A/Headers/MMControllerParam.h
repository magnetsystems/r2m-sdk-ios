/**
 * Copyright (c) 2012-2014 Magnet Systems, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
 
@interface MMControllerParam : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSNumber *optional;
@property(nonatomic, copy) NSString *style;
@property(nonatomic, copy) NSString *type;

@end
