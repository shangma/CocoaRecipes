//
//  StackTests.m
//  Graphique
//
//  Created by Sagar Natekar on 8/8/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "StackTests.h"
#import "Stack.h"

@implementation StackTests

- (void) testPushAndPop
{
    Stack *stack = [[Stack alloc] init];
    for (int i = 0; i < 1000; i++)
    {
        [stack push:[NSString stringWithFormat:@"String #%d", i]];
    }
    
    STAssertTrue([stack hasObjects], @"Stack should not be empty after pushing 1000 objects");
    
    for (int i = 999; i >= 0; i--)
    {
        NSString *string = (NSString *)[stack pop];
        NSString *comp = [NSString stringWithFormat:@"String #%d", i];
        STAssertEqualObjects(string, comp, NULL);
    }
    
    STAssertFalse([stack hasObjects], @"Stack should be empty after popping 1000 objects");
}

@end
