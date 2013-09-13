//
//  AppDelegate.h
//  DrawingFun
//
//  Created by Sagar Natekar on 9/10/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class StretchView;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet StretchView *stretchView;

- (IBAction)showOpenPanel:(id)sender;

@end
