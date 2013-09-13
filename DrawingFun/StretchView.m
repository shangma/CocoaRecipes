//
//  StretchView.m
//  DrawingFun
//
//  Created by Sagar Natekar on 9/10/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "StretchView.h"

@implementation StretchView

@synthesize image = _image;
@synthesize opacity = _opacity;

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
        _opacity = 1.0;
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
    
    if (_image)
    {
        NSRect imageRect;
        imageRect.origin = NSZeroPoint;
        imageRect.size = _image.size;
        NSRect drawingRect = [self currentRect];
        [_image drawInRect:drawingRect
                  fromRect:imageRect
                 operation:NSCompositeSourceOver
                  fraction:_opacity];
    }
}

- (NSRect) currentRect
{
    float minX = MIN(downPoint.x, currentPoint.x);
    float maxX = MAX(downPoint.x, currentPoint.x);
    float minY = MIN(downPoint.y, currentPoint.y);
    float maxY = MAX(downPoint.y, currentPoint.y);
    
    return NSMakeRect(minX, minY, maxX - minX, maxY - minY);
}

#pragma mark Accessors

- (NSImage *) image
{
    return _image;
}

- (void) setImage:(NSImage *)image
{
    _image = image;
    NSSize imageSize = [image size];
    downPoint = NSZeroPoint;
    currentPoint.x = downPoint.x + imageSize.width;
    currentPoint.y = downPoint.y + imageSize.height;
    [self setNeedsDisplay:YES];
}

- (float) opacity
{
    return _opacity;
}

- (void) setOpacity:(float)opacity
{
    _opacity = opacity;
    [self setNeedsDisplay:YES];
}

#pragma mark Events

- (void) mouseDown:(NSEvent *)theEvent
{
    NSPoint p = [theEvent locationInWindow];
    //Point to be converted from the window's coordinate system to the view's
    downPoint = [self convertPoint:p fromView:nil];
    currentPoint = downPoint;
    [self setNeedsDisplay:YES];
    
}

- (void) mouseDragged:(NSEvent *)theEvent
{
    NSPoint p = [theEvent locationInWindow];
    currentPoint = [self convertPoint:p fromView:nil];
    [self autoscroll:theEvent];
    [self setNeedsDisplay:YES];
}

- (void) mouseUp:(NSEvent *)theEvent
{
    NSPoint p = [theEvent locationInWindow];
    currentPoint = [self convertPoint:p fromView:nil];
    [self setNeedsDisplay:YES];
}
    

@end
