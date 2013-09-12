//
//  Person.m
//  TableViewSorting
//
//  Created by Sagar Natekar on 8/28/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id) init
{
    if (self = [super init]) {
        _name = @"Bob";
        _age = 40;
    }
    
    return self;
    
}

@end
