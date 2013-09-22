//
//  AppDelegate.m
//  LayerBackedView
//
//  Created by Sagar Natekar on 9/21/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.button.superview setWantsLayer:YES];
}

- (IBAction)buttonPressed:(id)sender
{
    [self.button setFrameCenterRotation:self.button.frameCenterRotation+10];
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor colorWithCalibratedRed:arc4random_uniform(2) green:arc4random_uniform(2) blue:arc4random_uniform(2) alpha:1]];
    [shadow setShadowBlurRadius:arc4random_uniform(10)];
    [shadow setShadowOffset:NSMakeSize((int)arc4random_uniform(21)-10, (int)arc4random_uniform(21)-10)];
    [[[self button] animator] setShadow:shadow];
}

@end
