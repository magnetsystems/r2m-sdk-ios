/**
 * Copyright (c) 2012-2014 Magnet Systems, Inc. All rights reserved.
 */
 
@interface MMControllerMethod : NSObject

@property(nonatomic, copy) NSString *method;

@property(nonatomic, copy) NSString *name;

@property(nonatomic, copy) NSArray *parameters;

@property(nonatomic, copy) NSString *path;

@property(nonatomic, copy) NSString *returnType;

@property(nonatomic, copy) NSSet *produces;

@property(nonatomic, copy) NSSet *consumes;

@property(nonatomic, strong) NSURL *baseURL;

@end
