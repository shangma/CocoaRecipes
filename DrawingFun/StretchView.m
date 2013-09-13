//
//  StretchView.m
//  DrawingFun
//
//  Created by Sagar Natekar on 9/10/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "StretchView.h"

@implementation StretchView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        srandom((unsigned)time(NULL));
        
        path = [NSBezierPath bezierPath];
        [path setLineWidth:3.0];
        NSPoint p = [self randomPoint];
        [path moveToPoint:p];
        int i;
        for (i=0; i<15; i++) {
            p = [self randomPoint];
            [path lineToPoint:p];
        }
        [path closePath];
    }
    
    return self;
}

- (NSPoint) randomPoint
{
    NSPoint result;
    NSRect r = [self bounds];
    result.x = r.origin.x + random()%(int)r.size.width;
    result.y = r.origin.y + random()%(int)r.size.height;
    return result;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSRect bounds = [self bounds];
    [[NSColor greenColor] set];
    [NSBezierPath fillRect:bounds];
    
    //Draw the path
    [[NSColor blueColor] set];
    [path fill];
}

#pragma mark Events

- (void) mouseDown:(NSEvent *)theEvent
{
    NSLog(@"mouseDown: %ld", [theEvent clickCount]);
}

- (void) mouseDragged:(NSEvent *)theEvent
{
    NSPoint p = [theEvent locationInWindow];
    NSLog(@"mouseDragged: %@", NSStringFromPoint(p));
}

- (void) mouseUp:(NSEvent *)theEvent
{
    NSLog(@"mouseUp");
}
    

@end
