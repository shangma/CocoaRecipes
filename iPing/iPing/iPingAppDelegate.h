//
//  iPingAppDelegate.h
//  iPing
//
//  Created by Sagar Natekar on 9/30/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface iPingAppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSTextView *outputView;
    IBOutlet NSTextField *hostField;
    IBOutlet NSButton *startButton;
    NSTask *task;
    NSPipe *pipe;
}

@property (assign) IBOutlet NSWindow *window;
- (IBAction)startStopPing:(id)sender;

@end
