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

#import <Kiwi/Kiwi.h>
#import "MMAssert.h"

SPEC_BEGIN(MMAssertSpec)

describe(@"Assertions", ^{
    
    context(@"MMAssert", ^{
        context(@"when called with a true expression", ^{
            
            it(@"should do nothing", ^{
                BOOL tester = NO;
                
                MMAssert(YES);
                
                tester = YES;
                [[theValue(tester) should] beTrue];
            });
        });
        
        context(@"when called with a false expression", ^{
            context(@"without a description", ^{
                it(@"should throw an exception with the default reason", ^{
                    
                    id loggerMock = [KWMock nullMockForClass:[MMLogger class]];
                    // TODO: Figure out how to capture the reason
                    // Then, we can test if the reason ends with __PRETTY_FUNCTION__.
                    KWCaptureSpy *spy = [loggerMock captureArgument:@selector(error:) atIndex:0];
                    
                    
                    [MMLogger stub:@selector(sharedLogger) andReturn:loggerMock];
                    [[loggerMock should] receive:@selector(error:) withCount:1 arguments:any()];
                    
                    [[theBlock(^{
                        MMAssert(NO);
                    }) should] raiseWithName:NSInternalInconsistencyException];
                    
                    NSString *reason = spy.argument;
                    
                    [[reason should] equal:@"%@"];
                });
            });
            
            context(@"with a description", ^{
                it(@"should throw an exception with reason containing the supplied description", ^{
                    
                    id loggerMock = [KWMock nullMockForClass:[MMLogger class]];
                    // TODO: Figure out how to capture the reason
                    // Then, we can test if the reason ends with the suppplied description
                    KWCaptureSpy *spy = [loggerMock captureArgument:@selector(error:) atIndex:0];
                    
                    
                    [MMLogger stub:@selector(sharedLogger) andReturn:loggerMock];
                    [[loggerMock should] receive:@selector(error:) withCount:1 arguments:any()];
                    
                    [[theBlock(^{
                        MMAssert(NO, "Oops!");
                    }) should] raiseWithName:NSInternalInconsistencyException];
                    
                    NSString *reason = spy.argument;
                    
                    [[reason should] equal:@"%@"];
                });
            });
        });

    });
    
    context(@"MMParameterAssert", ^{
        context(@"when called with a true expression", ^{
            
            it(@"should do nothing", ^{
                BOOL tester = NO;
                
                MMParameterAssert(YES);
                
                tester = YES;
                [[theValue(tester) should] beTrue];
            });
        });
        
        context(@"when called with a false expression", ^{
            it(@"should throw an exception with the default reason", ^{
                
                id loggerMock = [KWMock nullMockForClass:[MMLogger class]];
                // TODO: Figure out how to capture the reason
                // Then, we can test if the reason ends with __PRETTY_FUNCTION__.
                KWCaptureSpy *spy = [loggerMock captureArgument:@selector(error:) atIndex:0];
                
                
                [MMLogger stub:@selector(sharedLogger) andReturn:loggerMock];
                [[loggerMock should] receive:@selector(error:) withCount:1 arguments:any()];
                
                [[theBlock(^{
                    MMParameterAssert(NO);
                }) should] raiseWithName:NSInternalInconsistencyException];
                
                NSString *reason = spy.argument;
                
                [[reason should] equal:@"%@"];
            });
        });
        
    });
});

SPEC_END
