//
//  Stack.m
//  Graphique
//
//  Created by Sagar Natekar on 8/8/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "Stack.h"

@implementation Stack

- (id) init
{
    if (self = [super init])
    {
        stack = [NSMutableArray array];
    }
    
    return self;
}

- (void) push:(id)obj
{
    [stack addObject:obj];
}

- (id) pop
{
    id obj = [stack lastObject];
    [stack removeLastObject];
    return obj;
}

- (BOOL) hasObjects
{
    return stack.count > 0;
}

@end
