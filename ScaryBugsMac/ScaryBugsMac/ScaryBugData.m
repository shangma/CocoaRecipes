//
//  ScaryBugData.m
//  ScaryBugsMac
//
//  Created by Sagar Natekar on 7/23/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import "ScaryBugData.h"

@implementation ScaryBugData

- (id) initWithTitle:(NSString *)title rating:(float)rating
{
    if (self = [super init])
    {
        self.title = title;
        self.rating = rating;
    }
    return self;
}

@end
