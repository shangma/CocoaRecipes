//
//  AppController.m
//  ViewSwapping
//
//  Created by Sagar Natekar on 8/26/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "AppController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

enum {
    kFirstViewTag = 0,
    kSecondViewTag
};

NSString *const kFirstView  = @"FirstViewController";
NSString *const kSecondView = @"SecondViewController";

@implementation AppController

@synthesize ourView = _ourView;
@synthesize ourViewController = _ourViewController;

- (void) awakeFromNib
{
    [self changeViewController:kFirstViewTag];
}

- (IBAction)changeView:(id)sender
{
    [self changeViewController:[[sender selectedCell] tag]];
}

- (void) changeViewController:(NSInteger)tag
{
    [[_ourViewController view] removeFromSuperview];
    
    switch (tag) {
        case kFirstViewTag:
            _ourViewController = [[FirstViewController alloc] initWithNibName:kFirstView bundle:nil];
            break;
            
        case kSecondViewTag:
            _ourViewController = [[SecondViewController alloc] initWithNibName:kSecondView bundle:nil];
            break;
            
        default:
            break;
    }
    
    [_ourView addSubview:[_ourViewController view]];
    [[_ourViewController view] setFrame:[_ourView bounds]];
    [[_ourViewController view] setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
}

@end
