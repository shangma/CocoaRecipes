//
//  ScatteredAppDelegate.h
//  Scattered
//
//  Created by Sagar Natekar on 9/29/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface ScatteredAppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSView *view;
    CATextLayer *textLayer;
    
    NSOperationQueue *processingQueue;
}
@property (assign) IBOutlet NSWindow *window;

@end
