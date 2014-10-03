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

#import "MMControllerConfiguration.h"
#import "MMControllerConfigurationRegistry.h"
#import "MMAssert.h"

@interface MMControllerConfiguration ()

@end

@implementation MMControllerConfiguration

+ (instancetype)configurationWithName:(NSString *)name {
    NSDictionary *endpointDict = [MMControllerConfigurationRegistry sharedConfigurationRegistry][name];
    if (endpointDict) {
        MMControllerConfiguration *controllerConfiguration = [[self alloc] initWithBaseURL:[NSURL URLWithString:endpointDict[@"BaseURL"]]];
        if (endpointDict[@"TimeoutInterval"] != nil) {
            controllerConfiguration.timeoutInterval = [endpointDict[@"TimeoutInterval"] doubleValue];
        }
        if (endpointDict[@"AllowInvalidCertificates"] != nil) {
            controllerConfiguration.allowInvalidCertificates = [endpointDict[@"AllowInvalidCertificates"] boolValue];
        }
        
        return controllerConfiguration;
    }
    
    return nil;
}


- (instancetype)initWithBaseURL:(NSURL *)baseURL {

    MMParameterAssert(baseURL);

    self = [super init];
    if (self) {
        self.baseURL = baseURL;
        self.timeoutInterval = 60; // 60 seconds
        self.allowInvalidCertificates = NO;
    }
    return self;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToConfiguration:other];
}

- (BOOL)isEqualToConfiguration:(MMControllerConfiguration *)configuration {
    if (self == configuration)
        return YES;
    if (configuration == nil)
        return NO;
    if (self.baseURL != configuration.baseURL && ![self.baseURL isEqual:configuration.baseURL])
        return NO;
    if (self.shouldUseCredentialStorage != configuration.shouldUseCredentialStorage)
        return NO;
    if (self.credential != configuration.credential && ![self.credential isEqual:configuration.credential])
        return NO;
    if (self.timeoutInterval != configuration.timeoutInterval)
        return NO;
    return self.allowInvalidCertificates == configuration.allowInvalidCertificates;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.baseURL hash];
    hash = hash * 31u + self.shouldUseCredentialStorage;
    hash = hash * 31u + [self.credential hash];
    hash = hash * 31u + [@(self.timeoutInterval) hash];
    hash = hash * 31u + self.allowInvalidCertificates;
    return hash;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    MMControllerConfiguration *copy = (MMControllerConfiguration *) [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.baseURL = self.baseURL;
        copy.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
        copy.credential = self.credential;
        copy.timeoutInterval = self.timeoutInterval;
        copy.allowInvalidCertificates = self.allowInvalidCertificates;
    }

    return copy;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.baseURL = [coder decodeObjectForKey:@"self.baseURL"];
        self.shouldUseCredentialStorage = [coder decodeBoolForKey:@"self.shouldUseCredentialStorage"];
        self.credential = [coder decodeObjectForKey:@"self.credential"];
        self.timeoutInterval = [coder decodeDoubleForKey:@"self.timeoutInterval"];
        self.allowInvalidCertificates = [coder decodeBoolForKey:@"self.allowInvalidCertificates"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.baseURL forKey:@"self.baseURL"];
    [coder encodeBool:self.shouldUseCredentialStorage forKey:@"self.shouldUseCredentialStorage"];
    [coder encodeObject:self.credential forKey:@"self.credential"];
    [coder encodeDouble:self.timeoutInterval forKey:@"self.timeoutInterval"];
    [coder encodeBool:self.allowInvalidCertificates forKey:@"self.allowInvalidCertificates"];
}

@end
