//
//  TodoItem.m
//  TodoList
//
//  Created by Sagar Natekar on 7/21/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import "TodoItem.h"

@implementation TodoItem

@synthesize itemValue;

//Required to support sorting using NSSortDescriptor
- (id) copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    [copy setItemValue:[self.itemValue copyWithZone:zone]];
    
    return copy;
}

@end
