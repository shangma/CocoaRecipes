//
//  GroupItem.m
//  Graphique
//
//  Created by Sagar Natekar on 8/6/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "GroupItem.h"

@implementation GroupItem

@synthesize name, loaded;

- (id) init
{
    if (self = [super init]) {
        children = [[NSMutableArray alloc] init];
        loaded = NO;
    }
    
    return self;
}

- (void) addChild:(id)childNode
{
    [children addObject:childNode];
}

- (NSInteger) numberOfChildren
{
    return children.count;
}

- (id) childAtIndex:(NSUInteger)n
{
    return [children objectAtIndex:n];
}

- (NSString *) text
{
    return name;
}

- (void) reset
{
    [children removeAllObjects];
    loaded = NO;
}

@end
