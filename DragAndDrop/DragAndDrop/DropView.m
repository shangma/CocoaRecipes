//
//  DropView.m
//  DragAndDrop
//
//  Created by Sagar Natekar on 8/25/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "DropView.h"

@implementation DropView

@synthesize image;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //[self registerForDraggedTypes:[NSImage imagePasteboardTypes]];
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSURLPboardType]];
    }
    
    return self;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    //Check if source can become an image in the destination
    if ([NSImage canInitWithPasteboard:[sender draggingPasteboard]] && [sender draggingSourceOperationMask] & NSDragOperationCopy)
    {
        return NSDragOperationCopy;
    }
    else
        return NSDragOperationNone;
}

- (BOOL) prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL) performDragOperation:(id<NSDraggingInfo>)sender
{
    NSImage *newImage = [[NSImage alloc] initWithPasteboard:[sender draggingPasteboard]];
    self.image = newImage;
    return YES;
}

- (void) concludeDragOperation:(id<NSDraggingInfo>)sender
{
    //Calls drawRect:
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [super drawRect:dirtyRect];
    
    if (!image) {
        [[NSColor redColor] set];
        NSRectFill(dirtyRect);
    }
    else
    {
        [image drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    }
}

@end
