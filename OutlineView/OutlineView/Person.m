//
//  Person.m
//  OutlineView
//
//  Created by Sagar Natekar on 9/2/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id) init
{
    return [self initWithName:@"Test Name" age:0];
    
}

- (id) initWithName:(NSString *)name age:(int)age
{
    if (self = [super init])
    {
        _name = [name copy];
        _age = age;
        _children = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) addChild:(Person *)p
{
    [_children addObject:p];
}

- (void) removeChild:(Person *)p
{
    [_children removeObject:p];
}

@end
