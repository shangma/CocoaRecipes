//
//  AppDelegate.m
//  SplitView
//
//  Created by Sagar Natekar on 8/29/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //Get the text view embedded inside the leftmost scrollview
    NSTextView *leftTextView = [[[self.splitView subviews] objectAtIndex:0] documentView];
    [leftTextView setString:@"This is programmatic text"];
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    return proposedMinimumPosition+100;
    
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    return proposedMaximumPosition-100;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    //Only collapse left and right subviews, not the middle one
    NSView *left = [[splitView subviews] objectAtIndex:0];
    NSView *right = [[splitView subviews] objectAtIndex:2];
    
    if ([subview isEqual:left] || [subview isEqual:right]) {
        return YES;
    }
    else
        return NO;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex
{
    return YES;
}

@end
