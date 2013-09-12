//
//  ScaryBugDoc.m
//  ScaryBugsMac
//
//  Created by Sagar Natekar on 7/23/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import "ScaryBugDoc.h"
#import "ScaryBugData.h"

@implementation ScaryBugDoc

- (id) initWithTitle:(NSString *)title rating:(float)rating thumbImage:(NSImage *)thumbImage fullImage:(NSImage *)fullImage
{
    if (self = [super init])
    {
        self.data = [[ScaryBugData alloc] initWithTitle:title rating:rating];
        self.thumbImage = thumbImage;
        self.fullImage = fullImage;
    }
    
    return self;
}

@end
