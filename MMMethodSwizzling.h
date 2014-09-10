//
//  MMMethodSwizzling.h
//
//
//  Copyright (c) 2013 Magnet Systems, Inc. All rights reserved.
//

#import <objc/runtime.h>

// Workaround for change in imp_implementationWithBlock() with Xcode 4.5
// https://github.com/AFNetworking/AFNetworking/issues/417
#if defined(__IPHONE_6_0) || defined(__MAC_10_8)
#define AF_CAST_TO_BLOCK id
#else
#define AF_CAST_TO_BLOCK __bridge void *
#endif

static void AFSwizzleClassMethodWithClassAndSelectorUsingBlock(Class klass, SEL selector, id block) {
    Method originalMethod = class_getClassMethod(klass, selector);
    IMP implementation = imp_implementationWithBlock((AF_CAST_TO_BLOCK) block);
    class_replaceMethod(objc_getMetaClass([NSStringFromClass(klass) UTF8String]), selector, implementation, method_getTypeEncoding(originalMethod));
}
