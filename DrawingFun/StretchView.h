//
//  StretchView.h
//  DrawingFun
//
//  Created by Sagar Natekar on 9/10/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StretchView : NSView
{
    NSBezierPath *path;
    NSPoint downPoint;
    NSPoint currentPoint;
}

@property (nonatomic, assign) float opacity;
@property (nonatomic, strong) NSImage *image;

- (NSPoint) randomPoint;
- (NSRect) currentRect;

@end
