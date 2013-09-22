//
//  AppDelegate.h
//  LayerBackedView
//
//  Created by Sagar Natekar on 9/21/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSButton *button;

- (IBAction)buttonPressed:(id)sender;

@end
