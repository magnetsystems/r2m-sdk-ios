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
 
#import "MMRestTransporter_Private.h"
#import "MMControllerMethod_Private.h"
#import "MMValueTransformer.h"
#import "MMAssert.h"
#import "MMResourceNode.h"
#import "MMControllerConfiguration.h"
#import "MMController.h"

// arguments 0 and 1 are reserved
static int const kNumberOfReservedArguments = 2;
// options, success and failure
static int const kNumberOfCommonArguments = 2;

typedef enum {
    HTTPContentTypeFORM,
    HTTPContentTypeJSON,
    HTTPContentTypeString
} HTTPContentType;

@implementation MMRestTransporter

#pragma mark - Public API

+ (instancetype)transporter {
    return [[self alloc] init];
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithControllerMethod:(MMControllerMethod *)controllerMethod invocation:(NSInvocation *)anInvocation controllerConfiguration:(MMControllerConfiguration *)controllerConfiguration {

    MMParameterAssert(controllerMethod);
    MMParameterAssert(anInvocation);
    
    MMHTTPRequestOperationManager *manager = [self managerWithConfiguration:controllerConfiguration];
  
    MMRestApiCall *restApiCall = [self extractRequestParametersForInvocation:anInvocation controllerMethod:controllerMethod];

    AFHTTPRequestOperation *op = [manager HTTPRequestOperationWithRestApiCall:restApiCall success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSHTTPURLResponse *response = operation.response;
        MMAssert(![NSThread isMainThread], @"Cannot parse HTTP response on the main thread!");

        if (restApiCall.success) {
            NSError *parseError;
            [[MMLogger sharedLogger] verbose:@"Parsing response for type: %zd", restApiCall.returnTypeEnum];

            responseObject = [restApiCall.responseSerializer responseObjectForResponse:response data:responseObject error:&parseError];

            if (parseError) {
                [[MMLogger sharedLogger] error:@"Error parsing response = %@", parseError];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[MMLogger sharedLogger] verbose:@"Executing callback on main thread"];
                [self executeSuccessBlock:restApiCall.success platformReturnType:restApiCall.returnType controllerReturnType:restApiCall.returnTypeEnum responseObject:responseObject responseClass:restApiCall.responseClass];
            });
        }
    }                                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (restApiCall.failure) {
            typedef void(^FailureBlock)(NSError *);
            dispatch_async(dispatch_get_main_queue(), ^{
                FailureBlock failureBlock = restApiCall.failure;

                NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
                id errorResponse = mutableUserInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                [mutableUserInfo removeObjectForKey:AFNetworkingOperationFailingURLResponseErrorKey];
                mutableUserInfo[MMControllerErrorDomainFailingResponseErrorKey] = errorResponse;

                id errorResponseData = mutableUserInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                [mutableUserInfo removeObjectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
                mutableUserInfo[MMControllerErrorDomainFailingResponseDataErrorKey] = errorResponseData;

                NSError *magnetControllerError = [[NSError alloc] initWithDomain:MMControllerErrorDomain
                                                                            code:error.code
                                                                        userInfo:mutableUserInfo];

                failureBlock(magnetControllerError);
            });
        }
    }];

    [[MMLogger sharedLogger] verbose:@"returned call for controller"];

    return op;
}

#pragma mark - Private implementation

- (NSString *)basePathForControllerMethod:(MMControllerMethod *)controllerMethod invocation:(NSInvocation *)invocation {
    NSString *basePath = controllerMethod.path;
    MMAssert(basePath && [basePath length] > 0, @"Controller Path is invalid");

    // Remove leading slash "/"
    return [self removeLeadingSlash:basePath];
}

- (NSString *)removeLeadingSlash:(NSString *)basePath {
    if ([basePath hasPrefix:@"/"]) {
        basePath = [basePath substringFromIndex:1];
    }
    return basePath;
}

- (MMRestApiCall *)extractRequestParametersForInvocation:(NSInvocation *)anInvocation controllerMethod:(MMControllerMethod *)controllerMethod {
    // Initialize
    NSMutableDictionary *queryParameters;
    NSMutableDictionary *bodyParameters;
    NSMutableDictionary *headers = [NSMutableDictionary new];
    BOOL isFormUrlEncoded = NO;

    NSString *basePath = [self basePathForControllerMethod:controllerMethod invocation:anInvocation];

    // Iterate through the argument list and figure out the type of the argument and the HTTP semantics.
    NSUInteger numberOfArguments = [[anInvocation methodSignature] numberOfArguments];
    [[MMLogger sharedLogger] verbose:@"numberOfArguments = %lu", (unsigned long)numberOfArguments];
    // The cast is required so that we don't go out of bounds when numberOfArguments is 0.
    for (int i = 0; i < (int)(numberOfArguments - kNumberOfReservedArguments - kNumberOfCommonArguments); i++) {
        //            http://stackoverflow.com/questions/13268502/exc-bad-access-when-accessing-parameters-in-anddo-of-ocmock/13831074#13831074
        id argument;
        //            id argument;
        int index = (i + kNumberOfReservedArguments);

        MMControllerParam *parameter = controllerMethod.parameters[(NSUInteger) i];

        [[MMLogger sharedLogger] verbose:@"controller input type = %zd at index = %i", parameter.inputTypeEnum, i];

        argument = [self transformParameter:parameter invocation:anInvocation atIndex:index];

        /* Do not include nil arguments */
        if (argument) {
            NSString *parameterName = parameter.name;
            // TODO: handle unnamed parameters: https://magneteng.atlassian.net/browse/WON-2031
            if (parameterName && ![parameterName isEqualToString:@""]) {
                if ([parameter.style isEqualToString:@"TEMPLATE"]) {
                    if ([argument respondsToSelector:@selector(stringValue)]) {
                        argument = [argument stringValue];
                    }
                    if ([parameterName hasPrefix:@"magnet"]) {
                        parameterName = [parameterName stringByReplacingOccurrencesOfString:@"magnet" withString:@""];
                    }
                    basePath = [basePath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}", parameterName]
                                                                   withString:MMPercentEscapedQueryStringValueFromStringWithEncoding(argument, NSUTF8StringEncoding)
                                                                      options:NSCaseInsensitiveSearch
                                                                        range:NSMakeRange(0, [basePath length])];
                } else if ([parameter.style isEqualToString:@"HEADER"]) {
                    // This is not required because some arguments can add headers and we have to initialize headers before this point: example MMData
//                    if (!headers) {
//                        headers = [[NSMutableDictionary alloc] init];
//                    }
                    headers[parameterName] = argument;
                } else if ([parameter.style isEqualToString:@"QUERY"]) {
                    if (!queryParameters) {
                        queryParameters = [[NSMutableDictionary alloc] init];
                    }
                    queryParameters[parameterName] = argument;
                } else if ([parameter.style isEqualToString:@"MATRIX"]) {
                    NSString *matrixParameter = [self matrixParameterWithName:parameterName value:argument];
                    basePath = [basePath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}", parameterName] withString:matrixParameter];
                } else {
                    // If we have atleast one FORM parameter, marshall the request as application/x-www-form-urlencoded
                    if ([parameter.style isEqualToString:@"FORM"]) {
                        isFormUrlEncoded = YES;
                    }
                    if (!bodyParameters) {
                        bodyParameters = [[NSMutableDictionary alloc] init];
                    }
                    bodyParameters[parameterName] = argument;
                }
            }

        } else {
            MMAssert([parameter.optional boolValue], @"%@ should not be nil", parameter.name);
        }
    }

    if (([controllerMethod.method isEqualToString:MMStringFromRequestMethod(MMRequestMethodHEAD)] ||
            [controllerMethod.method isEqualToString:MMStringFromRequestMethod(MMRequestMethodGET)] ||
            [controllerMethod.method isEqualToString:MMStringFromRequestMethod(MMRequestMethodDELETE)]) && bodyParameters) {
        if (!queryParameters) {
            queryParameters = [[NSMutableDictionary alloc] init];
        }
        [queryParameters addEntriesFromDictionary:bodyParameters];
        bodyParameters = nil;
    }

    typedef void(^FailureBlock)(NSError *);

    // Get success and failure blocks
    //[anInvocation getArgument:&options atIndex:(numberOfArguments - 3)]; // options is always the third to last argument
    __unsafe_unretained id successBlock = nil;
    __unsafe_unretained FailureBlock failureBlock = nil;
    [anInvocation getArgument:&successBlock atIndex:(numberOfArguments - 2)]; // success block is always the second to last argument (penultimate)
    [anInvocation getArgument:&failureBlock atIndex:(numberOfArguments - 1)]; // failure block is always the last argument

    MMRestApiCall *restApiCall = [MMRestApiCall restApiCall];
    restApiCall.basePath = basePath;
    restApiCall.queryParameters = queryParameters;
    restApiCall.bodyParameters = bodyParameters;
    restApiCall.headers = headers.count ? headers : nil;
    restApiCall.isFormUrlEncoded = isFormUrlEncoded;
    
    restApiCall.returnType = [controllerMethod.returnType hasPrefix:@"_bean:"] ?
    [controllerMethod.returnType componentsSeparatedByString:@":"][0] :
    controllerMethod.returnType;
    
    restApiCall.returnTypeEnum = controllerMethod.returnTypeEnum;
    restApiCall.returnsString = controllerMethod.returnsString;
    restApiCall.httpMethod = MMRequestMethodFromString(controllerMethod.method);
    // Copy is important! Since the successBlock is an id, the copy is required
    restApiCall.success = [successBlock copy];
    restApiCall.failure = failureBlock;
    restApiCall.responseClass = [controllerMethod.returnType hasPrefix:@"_bean:"] ?
                                                    NSClassFromString([controllerMethod.returnType componentsSeparatedByString:@":"][1]) :nil;
    

    [[MMLogger sharedLogger] verbose:@"restApiCall = %@", restApiCall];

    return restApiCall;
}

- (id)transformParameter:(MMControllerParam *)parameter invocation:(NSInvocation *)anInvocation atIndex:(int)index {

    id argument;
    // Transform the argument!
    switch (parameter.inputTypeEnum) {
        case MMControllerInputTypeString:
        case MMControllerInputTypeBigDecimal:
        case MMControllerInputTypeBigInteger:{
            __unsafe_unretained id arg;
            [anInvocation getArgument:&arg atIndex:index];
            argument = [self safeCopy:arg];
            break;
        }
        case MMControllerInputTypeUri:{
            __unsafe_unretained NSURL *a;
            [anInvocation getArgument:&a atIndex:index];
            argument = [[MMValueTransformer urlTransformer] reverseTransformedValue:[self safeCopy:a]];
            break;
        }
        case MMControllerInputTypeList:{
            __unsafe_unretained NSArray *a;
            [anInvocation getArgument:&a atIndex:index];
            NSString *listType = [parameter.type componentsSeparatedByString:@":"][1];
            argument = [[MMValueTransformer listTransformerForType:listType] reverseTransformedValue:[self safeCopy:a]];
            break;
        }
        case MMControllerInputTypeData:{
            break;
        }
        case MMControllerInputTypeDate: {
            __unsafe_unretained NSDate *a;
            [anInvocation getArgument:&a atIndex:index];
            argument = [[MMValueTransformer dateTransformer] reverseTransformedValue:[self safeCopy:a]];
            break;
        }
        case MMControllerInputTypeEnum:{
            NSUInteger a;
            [anInvocation getArgument:&a atIndex:index];
            NSString *enumType = [parameter.type componentsSeparatedByString:@":"][1];
            argument = [[MMValueTransformer enumTransformerForKey:enumType] reverseTransformedValue:@(a)];
            break;
        }
        case MMControllerInputTypeBoolean:{
            BOOL a;
            [anInvocation getArgument:&a atIndex:index];
            argument = [[MMValueTransformer booleanTransformer] reverseTransformedValue:@(a)];
            break;
        }
        case MMControllerInputTypeByte:{
            char a;
            [anInvocation getArgument:&a atIndex:index];
            argument = @(a);
            break;
        }
        case MMControllerInputTypeChar:{
            unichar a;
            [anInvocation getArgument:&a atIndex:index];
            argument = [NSString stringWithFormat:@"%C", a];
            break;
        }
        case MMControllerInputTypeShort:{
            short a;
            [anInvocation getArgument:&a atIndex:index];
            argument = @(a);
            break;
        }
        case MMControllerInputTypeInteger:{
            int a;
            [anInvocation getArgument:&a atIndex:index];
            argument = @(a);
            break;
        }
        case MMControllerInputTypeLong:{
            long long a;
            [anInvocation getArgument:&a atIndex:index];
            argument = @(a);
            break;
        };
        case MMControllerInputTypeFloat:{
            float a;
            [anInvocation getArgument:&a atIndex:index];
            argument = [NSString stringWithFormat:@"%f", a];
            break;
        };
        case MMControllerInputTypeDouble:{
            double a;
            [anInvocation getArgument:&a atIndex:index];
            argument = [NSString stringWithFormat:@"%f", a];
            break;
        };
        case MMControllerInputTypeBytes:{
            __unsafe_unretained NSData *myData;
            [anInvocation getArgument:&myData atIndex:index];
            argument = [[MMValueTransformer dataTransformer] reverseTransformedValue:[self safeCopy:myData]];
            break;
        }

        case MMControllerInputTypeReference:{
            __unsafe_unretained NSValue *value;
            [anInvocation getArgument:&value atIndex:index];
            NSString *referenceType = [parameter.type componentsSeparatedByString:@":"][1];
            argument = [[MMValueTransformer valueObjTransformerForType:referenceType] reverseTransformedValue:[self safeCopy:value]];
            break;
        }
        case MMControllerInputTypeMagnetNode:{
            __unsafe_unretained id arg;
            [anInvocation getArgument:&arg atIndex:index];
            argument = [[MMValueTransformer resourceNodeTransformerForClass:[MMResourceNode class]] reverseTransformedValue:[self safeCopy:arg]];
            break;
        }
    }
    return argument;
}

- (void)executeSuccessBlock:(id)successBlock
         platformReturnType:(NSString *)platformReturnType
       controllerReturnType:(MMControllerReturnType)returnTypeEnumValue
             responseObject:(id)responseObject
              responseClass:(Class)responseClass {
    [[MMLogger sharedLogger] verbose:@"return type = %zd", returnTypeEnumValue];

    switch (returnTypeEnumValue) {
        case MMControllerReturnTypeVoid:{
            typedef void(^SuccessBlock)(id);
            SuccessBlock successBlockToExecute = successBlock;
            successBlockToExecute(nil);
            break;
        }
        case MMControllerReturnTypeString:{
            typedef void(^SuccessBlock)(NSString *);
            SuccessBlock successBlockToExecute = successBlock;
            successBlockToExecute(responseObject);
            break;
        }
        case MMControllerReturnTypeBoolean:{
            typedef void(^SuccessBlock)(BOOL);
            SuccessBlock successBlockToExecute = successBlock;
            successBlockToExecute([[[MMValueTransformer booleanTransformer] transformedValue:@([responseObject boolValue])] boolValue]);
            break;
        }
        case MMControllerReturnTypeByte:{
            typedef void(^SuccessBlock)(char);
            SuccessBlock successBlockToExecute = successBlock;
            char val = (char) [responseObject integerValue];
            successBlockToExecute(val);
            break;
        }
        case MMControllerReturnTypeChar:{
            typedef void(^SuccessBlock)(unichar);
            SuccessBlock successBlockToExecute = successBlock;
            unichar val = [[[MMValueTransformer unicharTransformer] transformedValue:responseObject] unsignedShortValue];
            successBlockToExecute(val);
            break;
        }
        case MMControllerReturnTypeShort:{
            typedef void(^SuccessBlock)(short);
            SuccessBlock successBlockToExecute = successBlock;
            short val = (short) [responseObject integerValue];
            successBlockToExecute(val);
            break;
        }
        case MMControllerReturnTypeInteger:{
            typedef void(^SuccessBlock)(int);
            SuccessBlock successBlockToExecute = successBlock;
            int val = [responseObject intValue];
            successBlockToExecute(val);
            break;
        }
        case MMControllerReturnTypeLong:{
            typedef void(^SuccessBlock)(long long);
            SuccessBlock successBlockToExecute = successBlock;
            long long val = [[[MMValueTransformer longLongTransformer] transformedValue:responseObject] longLongValue];
            successBlockToExecute(val);
            break;
        }
        case MMControllerReturnTypeFloat:{
            typedef void(^SuccessBlock)(float);
            SuccessBlock successBlockToExecute = successBlock;
            float val = [responseObject floatValue];
            successBlockToExecute(val);
            break;
        }
        case MMControllerReturnTypeDouble:{
            typedef void(^SuccessBlock)(double);
            SuccessBlock successBlockToExecute = successBlock;
            double val = [responseObject doubleValue];
            successBlockToExecute(val);
            break;
        }
        case MMControllerReturnTypeBigDecimal:
            // FIXME: Should BigInteger from java be mapped to NSDecimalNumber?
        case MMControllerReturnTypeBigInteger:{
            typedef void(^SuccessBlock)(NSDecimalNumber *);
            SuccessBlock successBlockToExecute = successBlock;
            NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:responseObject];
            successBlockToExecute(val);
            break;
        }
        case MMControllerReturnTypeDate:{
            typedef void(^SuccessBlock)(NSDate *);
            SuccessBlock successBlockToExecute = successBlock;
            NSDate *val = [[MMValueTransformer dateTransformer] transformedValue:responseObject];
            successBlockToExecute(val);
            break;
        }
        case MMControllerReturnTypeUri:
        {
            typedef void(^SuccessBlock)(NSURL *);
            SuccessBlock successBlockToExecute = successBlock;
            NSURL *val = [[MMValueTransformer urlTransformer] transformedValue:responseObject];
            successBlockToExecute(val);
            break;
        }
        case MMControllerReturnTypeList:{
            typedef void(^SuccessBlock)(NSArray *);
            SuccessBlock successBlockToExecute = successBlock;

            NSString *listType;


            listType = [platformReturnType componentsSeparatedByString:@":"].count > 2 ?
                    [NSString stringWithFormat:@"%@:%@",
                                               [platformReturnType componentsSeparatedByString:@":"][1],
                                               [platformReturnType componentsSeparatedByString:@":"][2]] :
                    [platformReturnType componentsSeparatedByString:@":"][1];

            MMAssert([responseObject isKindOfClass:[NSArray class]], @"responseObject should be an array");
            NSArray *val = [[MMValueTransformer listTransformerForType:listType] transformedValue:responseObject];
//            NSArray *val = responseObject;
            successBlockToExecute(val);
            break;
        }
        case MMControllerReturnTypeData:{
            break;
        }
        case MMControllerReturnTypeBytes:{
            typedef void(^SuccessBlock)(NSData *);
            SuccessBlock successBlockToExecute = successBlock;
            NSData *decodedData = [[MMValueTransformer dataTransformer] transformedValue:responseObject];
            successBlockToExecute(decodedData);
            break;
        }
        case MMControllerReturnTypeMagnetNode:{
            typedef void(^SuccessBlock)(MMResourceNode *);
            SuccessBlock successBlockToExecute = successBlock;
            MMAssert([responseObject isKindOfClass:[NSDictionary class]], @"responseObject should be a dictionary");
            NSError *hydrateObjectError;

            MMResourceNode *val;
            val = [MTLJSONAdapter modelOfClass:responseClass fromJSONDictionary:responseObject error:&hydrateObjectError];

//            MMResourceNode *val = [MTLJSONAdapter modelOfClass:MMResourceNode.class fromJSONDictionary:responseObject error:&hydrateObjectError];
            if (hydrateObjectError) {
                [[MMLogger sharedLogger] error:@"Error hydrating object = %@", hydrateObjectError];
            } else {
                successBlockToExecute(val);
            }
            break;
        }
        case MMControllerReturnTypeReference:{
            typedef void(^SuccessBlock)(NSValue *);
            SuccessBlock successBlockToExecute = successBlock;
            NSString *referenceType = [platformReturnType componentsSeparatedByString:@":"][1];
            NSValue *val = [[MMValueTransformer valueObjTransformerForType:referenceType] transformedValue:responseObject];
            successBlockToExecute(val);
            break;
        }
        case MMControllerReturnTypeEnum:{
            typedef void(^SuccessBlock)(NSUInteger);
            SuccessBlock successBlockToExecute = successBlock;
            NSString *enumType = [platformReturnType componentsSeparatedByString:@":"][1];
            NSUInteger enumValue = [[[MMValueTransformer enumTransformerForKey:enumType] transformedValue:responseObject] unsignedIntegerValue];
            successBlockToExecute(enumValue);
            break;
        }
    }
}

- (NSString *)matrixParameterWithName:(NSString *)name value:(__unsafe_unretained id)value {
    // md5("magnet") = "59cfa26c741d65f06e84a3afb4583677"
    NSString *dummyUrlString = @"http://59cfa26c741d65f06e84a3afb4583677.com";

    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:dummyUrlString parameters:@{name : value} error:nil];
    // Remove "dummy URL" + "?"
    NSString *matrixParameter = [[[request URL] absoluteString] substringFromIndex:([dummyUrlString length] + 1)];
    return matrixParameter;
}

- (id)safeCopy:(id)argument {
    if ([argument conformsToProtocol:@protocol(NSCopying)]) {
        return [argument copy];
    }
    return argument;
}

- (MMHTTPRequestOperationManager *)managerWithConfiguration:(MMControllerConfiguration *)controllerConfiguration {

    MMHTTPRequestOperationManager *manager;

    if (self.managers[controllerConfiguration]) {
        manager = self.managers[controllerConfiguration];
    } else {
        manager = [[MMHTTPRequestOperationManager alloc] initWithBaseURL:controllerConfiguration.baseURL];
        manager.credential = controllerConfiguration.credential;
        manager.shouldUseCredentialStorage = controllerConfiguration.shouldUseCredentialStorage;
        manager.requestSerializer.timeoutInterval = controllerConfiguration.timeoutInterval;
        manager.securityPolicy.allowInvalidCertificates = controllerConfiguration.allowInvalidCertificates;
        self.managers[controllerConfiguration] = manager;
    }

    return manager;
}

#pragma mark - Overriden getters

- (NSMutableDictionary *)managers {
    if (!_managers) {
        _managers = [NSMutableDictionary dictionary];
    }
    return _managers;
}

@end
