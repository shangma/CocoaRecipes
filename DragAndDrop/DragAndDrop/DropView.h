//
//  DropView.h
//  DragAndDrop
//
//  Created by Sagar Natekar on 8/25/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DropView : NSView  <NSDraggingDestination>
{
    NSImage *image;
}

@property (strong) NSImage *image;

@end
