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
 
#import "MMTransporter.h"
#import "MMControllerMethod.h"
#import "MMRestTransporter.h"
#import "MMAssert.h"

@interface MMTransporter ()

@property (nonatomic, strong) MMRestTransporter *restTransporter;

@end

@implementation MMTransporter

#pragma mark - Public API

+ (instancetype)transporter {
    return [[self alloc] init];
}

+ (instancetype)sharedTransporter {
    static MMTransporter *_sharedTransporter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTransporter = [MMTransporter transporter];
    });

    return _sharedTransporter;
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithControllerMethod:(MMControllerMethod *)controllerMethod invocation:(NSInvocation *)invocation controllerConfiguration:(MMControllerConfiguration *)controllerConfiguration {

    MMParameterAssert(controllerMethod);
    MMParameterAssert(invocation);

    // Right now, we only support REST controllers, but in the future, we will support other transports

    return [self.restTransporter HTTPRequestOperationWithControllerMethod:controllerMethod invocation:invocation controllerConfiguration:controllerConfiguration];

}

#pragma mark - Overriden getters

- (MMRestTransporter *)restTransporter {
    if (!_restTransporter) {
        _restTransporter = [MMRestTransporter transporter];
    }
    return _restTransporter;
}


@end
