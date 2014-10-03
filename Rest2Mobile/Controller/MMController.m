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

#import "MMController_Private.h"
#import "MMTransporter.h"
#import "MMLogger.h"
#import "MMControllerConfiguration.h"
#import "MMAssert.h"
#import "MMControllerMethod.h"
#import "MMCall_Private.h"
#import <AFNetworking/AFNetworking.h>

NSString * const MMControllerErrorDomain = @"com.magnet.iOS.Rest2Mobile.error.serialization.response";
NSString * const MMControllerErrorDomainFailingResponseErrorKey = @"com.magnet.iOS.Rest2Mobile.serialization.response.error.response";
NSString * const MMControllerErrorDomainFailingResponseDataErrorKey = @"com.magnet.iOS.Rest2Mobile.serialization.response.error.data";

@interface MMController ()

@property(nonatomic, strong) MMTransporter *sharedTransporter;

@end

@implementation MMController

#pragma mark - Initializers

- (instancetype)initWithConfiguration:(MMControllerConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.configuration = configuration;
    }
    return self;
}

#pragma mark - Public API

+ (NSDictionary *)metaData {
    return nil;
}

#pragma mark - NSObject

- (void)forwardInvocation:(NSInvocation *)invocation {

    NSArray *selectorParts = [NSStringFromSelector([invocation selector]) componentsSeparatedByString:@":"];

    NSString *selectorName = [selectorParts[0] stringByReplacingOccurrencesOfString:@"WithSuccess" withString:@""];

    NSString *controllerLookupKey = [NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), selectorName];

    [[MMLogger sharedLogger] verbose:@"controller look up key = %@", controllerLookupKey];

    MMControllerMethod *controllerMethod = [[self class] metaData][controllerLookupKey];

    MMAssert(controllerMethod != nil, @"Controller meta data is missing");

    if (!self.configuration && controllerMethod.baseURL) {
       self.configuration = [controllerMethod.baseURL.absoluteString hasSuffix:@"/"] ?
                                                            [[MMControllerConfiguration alloc] initWithBaseURL:controllerMethod.baseURL] :
                                                                    [[MMControllerConfiguration alloc] initWithBaseURL:
                                                                            [NSURL URLWithString:[NSString stringWithFormat:@"%@/",
                                                                                                  [controllerMethod.baseURL absoluteString]]]];
    }

    AFHTTPRequestOperation *operation = [self.sharedTransporter HTTPRequestOperationWithControllerMethod:controllerMethod invocation:invocation controllerConfiguration:self.configuration];

    MMCall *call = [[MMCall alloc] init];
    call.underlyingOperation = operation;
    call.callId = [NSUUID UUID];

    [[MMLogger sharedLogger] debug:@"callId = %@", call.callId];

    MMCall *unsafeCall = call;
    [invocation setReturnValue:&unsafeCall];

//    [call start];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:call];
//    [call cancel];

}

#pragma mark - Overriden getters

- (MMTransporter *)sharedTransporter {
    if (!_sharedTransporter) {
        _sharedTransporter = [MMTransporter sharedTransporter];
    }
    return _sharedTransporter;
}

@end
