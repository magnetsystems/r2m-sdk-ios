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
 
#import "MMHTTPUtilities.h"


BOOL MMIsSpecificRequestMethod(MMRequestMethod method)
{
    // check for a power of two
    return !(method & (method - 1));
}

NSString *MMStringFromRequestMethod(MMRequestMethod method)
{
    switch (method) {
        case MMRequestMethodGET:     return @"GET";
        case MMRequestMethodPOST:    return @"POST";
        case MMRequestMethodPUT:     return @"PUT";
        case MMRequestMethodPATCH:   return @"PATCH";
        case MMRequestMethodDELETE:  return @"DELETE";
        case MMRequestMethodHEAD:    return @"HEAD";
        case MMRequestMethodOPTIONS: return @"OPTIONS";
        default:                     break;
    }
    return nil;
}

MMRequestMethod MMRequestMethodFromString(NSString *methodName)
{
    if      ([methodName isEqualToString:@"GET"])     return MMRequestMethodGET;
    else if ([methodName isEqualToString:@"POST"])    return MMRequestMethodPOST;
    else if ([methodName isEqualToString:@"PUT"])     return MMRequestMethodPUT;
    else if ([methodName isEqualToString:@"DELETE"])  return MMRequestMethodDELETE;
    else if ([methodName isEqualToString:@"HEAD"])    return MMRequestMethodHEAD;
    else if ([methodName isEqualToString:@"PATCH"])   return MMRequestMethodPATCH;
    else if ([methodName isEqualToString:@"OPTIONS"]) return MMRequestMethodOPTIONS;
    else                                              @throw [NSException exceptionWithName:NSInvalidArgumentException
                                                                                     reason:[NSString stringWithFormat:@"The given HTTP request method name `%@` does not correspond to any known request methods.", methodName]
                                                                                   userInfo:nil];
}

static NSString * const kMMCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

NSString *MMPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kMMCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}
