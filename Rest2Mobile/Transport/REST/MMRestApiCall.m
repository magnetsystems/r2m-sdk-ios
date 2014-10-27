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
 
#import "MMRestApiCall.h"
#import "MMStringResponseSerializer.h"

@interface MMRestApiCall()

@property (nonatomic, readwrite) AFHTTPResponseSerializer *responseSerializer;

@end

@implementation MMRestApiCall

#pragma mark - Public API

+ (instancetype)restApiCall {
    return [[self alloc] init];
}

- (AFHTTPResponseSerializer *)responseSerializer {
    AFHTTPResponseSerializer *responseSerializer;
    if (self.returnsString) {
        responseSerializer = [MMStringResponseSerializer serializer];
    } else {
        responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    }
    return responseSerializer;
}

@end
