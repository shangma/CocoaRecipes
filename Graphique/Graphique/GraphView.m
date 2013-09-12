//
//  GraphView.m
//  Graphique
//
//  Created by Sagar Natekar on 8/8/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "GraphView.h"
#import "GraphTableViewController.h"

@implementation GraphView

@synthesize controller;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    //1. Find the boundaries
    float minDomain = CGFLOAT_MAX;
    float maxDomain = CGFLOAT_MIN;
    
    float minRange = CGFLOAT_MAX;
    float maxRange = CGFLOAT_MIN;
    
    for (NSValue *value in controller.values)
    {
        NSPoint point = [value pointValue];
        if (point.x < minDomain) {
            minDomain = point.x;
        }
        if (point.x > maxDomain) {
            maxDomain = point.x;
        }
    
        if (point.y < minRange) {
            minRange = point.y;
        }
        if (point.y > maxRange) {
            maxRange = point.y;
        }
    }

    //2. Define scaling factors
    float hScale = self.bounds.size.width / (maxDomain - minDomain);
    float vScale = self.bounds.size.height / (maxRange - minRange);

    //3. Paint the background
    NSColor *background = [NSColor colorWithDeviceRed:0.30 green:0.58 blue:1.0 alpha:1.0];
    NSColor *axisColor = [NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    NSColor *gridColorLight = [NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0
                                                alpha:0.5];
    NSColor *gridColorLighter = [NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0
                                                  alpha:0.25];
    // Get the line color from the user defaults
    NSData *colorData = [[NSUserDefaults standardUserDefaults] dataForKey:@"lineColor"];
    NSColor *curveColor = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];

    [background set];
    NSRectFill(dirtyRect);

    //4. Plot the graph

    if(controller.values.count == 0) return;

    {
        //Paint domain axis
        NSBezierPath *domainAxis = [NSBezierPath bezierPath];
        [domainAxis setLineWidth:1];
        NSPoint startPoint = { 0, -minRange * vScale };
        NSPoint endPoint = { self.bounds.size.width , -minRange *vScale };
        [domainAxis moveToPoint:startPoint];
        [domainAxis lineToPoint:endPoint];
        [axisColor set];
        [domainAxis stroke];
    }

    {
        //Paint range axis
        NSBezierPath *rangeAxis = [NSBezierPath bezierPath];
        [rangeAxis setLineWidth: 1];
        NSPoint startPoint = { -minDomain * hScale, 0 };
        NSPoint endPoint = { -minDomain * hScale, self.bounds.size.height };
        [rangeAxis moveToPoint:startPoint];
        [rangeAxis lineToPoint:endPoint];
        [axisColor set];
        [rangeAxis stroke];
    }

    {
        //Paint the grid. Every 10 steps, use a less transparent grid path for major lines
        NSBezierPath *grid = [NSBezierPath bezierPath];
        NSBezierPath *lighterGrid = [NSBezierPath bezierPath];
        for(int col = minDomain;col<maxDomain;col++)
        {
            NSPoint startPoint = { (col - minDomain) * hScale, 0 };
            NSPoint endPoint = { (col - minDomain) * hScale, self.bounds.size.height };
            if(col%10 == 0)
            {
                [grid moveToPoint:startPoint];
                [grid lineToPoint:endPoint];
            }
            else
            {
                [lighterGrid moveToPoint:startPoint];
                [lighterGrid lineToPoint:endPoint];
            }
        }
        
        int vStep = pow(10, log10(maxRange - minRange)-2);
        if(vStep == 0)
            vStep = 1;
        
        for(int row = -vStep; row >= minRange; row-= vStep)
        {
            NSPoint startPoint = { 0, (row - minRange) * vScale};
            NSPoint endPoint = { self.bounds.size.width * hScale, (row - minRange) * vScale };
            if(row % (vStep*10) == 0)
            {
                [grid moveToPoint:startPoint];
                [grid lineToPoint:endPoint];
            }
            else
            {
                [lighterGrid moveToPoint:startPoint];
                [lighterGrid lineToPoint:endPoint];
            }
        }
        
        for(int row=vStep; row<maxRange; row += vStep)
        {
            NSPoint startPoint = { 0, (row - minRange) * vScale};
            NSPoint endPoint = { self.bounds.size.width * hScale, (row - minRange) * vScale };
            if(row % (vStep*10) == 0)
            {
                [grid moveToPoint:startPoint];
                [grid lineToPoint:endPoint];
            }
            else
            {
                [lighterGrid moveToPoint:startPoint];
                [lighterGrid lineToPoint:endPoint];
            }
        }
        
        [gridColorLighter set];
        [lighterGrid stroke];
        [gridColorLight set];
        [grid stroke];
    }

    // Paint the curve
    {
        NSBezierPath *curve = nil;
        for(NSValue *value in controller.values)
        {
            NSPoint point = [value pointValue];
            NSPoint pointForView = { (point.x - minDomain) * hScale, (point.y - minRange) *
                vScale };
            if(curve == nil)
            {
                curve = [NSBezierPath bezierPath];
                [curve setLineWidth:2.0];
                [curve moveToPoint:pointForView];
            }
            else
            {
                [curve lineToPoint:pointForView];
            }
        }
        [curveColor set];
        [curve stroke];
    }

}

@end
