//
//  Person.m
//  RaiseMan
//
//  Created by Sagar Natekar on 7/21/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize expectedRaise;
@synthesize personName;

- (id) init
{
    if (self = [super init])
    {
        expectedRaise = 0.05;
        personName = @"New Person";
    }
    
    return self;
}

- (void) setNilValueForKey:(NSString *)key
{
    if ([key isEqual:@"expectedRaise"]) {
        [self setExpectedRaise:0.0];
    }
    else
    {
        [super setNilValueForKey:key];
    }
}

- (void) encodeWithCoder:(NSCoder *) coder
{
    [coder encodeObject:personName forKey:@"personName"];
    [coder encodeFloat:expectedRaise forKey:@"expectedRaise"];
    
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        personName = [aDecoder decodeObjectForKey:@"personName"];
        expectedRaise = [aDecoder decodeFloatForKey:@"expectedRaise"];
    }
    
    return self;
}


@end
