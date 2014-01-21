//
//  AppController.m
//  CollectionView
//
//  Created by Sagar Natekar on 10/22/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import "AppController.h"
#import "Student.h"

@implementation AppController

- (void)awakeFromNib
{
    Student *s = [[Student alloc] init];
    s.name = @"Lucas";
    s.rating = 4;
    _students = [[NSMutableArray alloc] init];
    [arrayController addObject:s];
}

@end
