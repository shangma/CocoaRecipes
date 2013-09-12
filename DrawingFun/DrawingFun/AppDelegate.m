//
//  AppDelegate.m
//  DrawingFun
//
//  Created by Sagar Natekar on 9/10/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    //Create a button programmatically
    NSView *superView = [[self window] contentView];
    NSRect rect = NSMakeRect(100, 10, 250, 25);
    NSButton *button = [[NSButton alloc] initWithFrame:rect];
    [button setTitle:@"Click Me !"];
    [superView addSubview:button];

}

@end
