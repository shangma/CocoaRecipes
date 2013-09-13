//
//  AppDelegate.m
//  DrawingFun
//
//  Created by Sagar Natekar on 9/10/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "AppDelegate.h"
#import "StretchView.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
}

- (IBAction)showOpenPanel:(id)sender
{
    __block NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSImage imageFileTypes]];
    
    [panel beginSheetModalForWindow:[_stretchView window] completionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            NSImage *image = [[NSImage alloc] initWithContentsOfURL:[panel URL]];
            [_stretchView setImage:image];
        }
        panel = nil;
    }];
}

@end
