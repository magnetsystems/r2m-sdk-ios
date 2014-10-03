/*
 * Created by Blake Watters on 8/24/12.
 * Copyright (c) 2012 RestKit. All rights reserved.
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

// Code taken from RestKit: https://github.com/RestKit/RestKit/blob/c17a180b729028223d2825b96f707f1cbe5a06a9/Code/ObjectMapping/RKHTTPUtilities.h
// Changed the prefix to MM
/**
 HTTP methods for requests
 */
typedef NS_OPTIONS(NSInteger, MMRequestMethod){
    /**
     GET HTTP method.
     */
    MMRequestMethodGET          = 1 << 0,
    /**
     POST HTTP method.
     */
    MMRequestMethodPOST         = 1 << 1,
    /**
     PUT HTTP method.
     */
    MMRequestMethodPUT          = 1 << 2,
    /**
     DELETE HTTP method.
     */
    MMRequestMethodDELETE       = 1 << 3,
    /**
     HEAD HTTP method.
     */
    MMRequestMethodHEAD         = 1 << 4,
    /**
     PATCH HTTP method.
     */
    MMRequestMethodPATCH        = 1 << 5,
    /**
     OPTIONS HTTP method.
     */
    MMRequestMethodOPTIONS      = 1 << 6,
    /**
     Any HTTP method.
     */
    MMRequestMethodAny          = (MMRequestMethodGET |
            MMRequestMethodPOST |
            MMRequestMethodPUT |
            MMRequestMethodDELETE |
            MMRequestMethodHEAD |
            MMRequestMethodPATCH |
            MMRequestMethodOPTIONS)
};

/**
 Returns YES if the given HTTP request method is an exact match of the MMRequestMethod enum, and NO if it's a bit mask combination.
 */
BOOL MMIsSpecificRequestMethod(MMRequestMethod method);

/**
 Returns the corresponding string for value for a given HTTP request method.

 For example, given `MMRequestMethodGET` would return `@"GET"`.

 @param method The request method to return the corresponding string value for. The given request method must be specific.
 */
NSString *MMStringFromRequestMethod(MMRequestMethod method);

/**
 Returns the corresponding request method value for a given string.

 For example, given `@"PUT"` would return `@"MMRequestMethodPUT"`
 */
MMRequestMethod MMRequestMethodFromString(NSString *);

/**
Code taken from https://github.com/AFNetworking/AFNetworking/blob/bc7f5a6a4555d1a0cea8f886ced22041350f2147/AFNetworking/AFURLRequestSerialization.m
Changed the prefix to MM
Returns a safe string. Safe for use, say, as a parameter to a URL.

For example, given `@"hell & brimstone + earthly/delight"` would return `@"hell%20%26%20brimstone%20%2B%20earthly%2Fdelight"`.

@param string The string to encode.
@param encoding The encoding to be used.
*/
NSString *MMPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string, NSStringEncoding encoding);
