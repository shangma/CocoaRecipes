//
//  KeyFrameView.m
//  KeyFrameAnimation
//
//  Created by Sagar Natekar on 9/21/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "KeyFrameView.h"
#import <QuartzCore/QuartzCore.h>

@implementation KeyFrameView
{
    NSImageView *_imageView;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width/4.0, frame.size.height/4.0)];
        [_imageView setImageScaling:NSImageScaleAxesIndependently];
        [_imageView setImage:[NSImage imageNamed:@"me.png"]];
        [self addSubview:_imageView];
        [self setUpAnimation];
    }
    
    return self;
}

- (void) setUpAnimation
{
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animation];
    keyFrameAnimation.duration = 5.0;

    keyFrameAnimation.calculationMode = kCAAnimationPaced;
    
//    CGFloat x = [_imageView frame].origin.x;
//    CGFloat y = [_imageView frame].origin.y;
//    
//    keyFrameAnimation.values = @[[NSValue valueWithPoint:NSMakePoint(x, y)],
//                                 [NSValue valueWithPoint:NSMakePoint(x, y+200)],
//                                 [NSValue valueWithPoint:NSMakePoint(x+300, y+200)],
//                                 [NSValue valueWithPoint:NSMakePoint(x+300, y)],
//                                 [NSValue valueWithPoint:NSMakePoint(x, y)]];
//    
//    keyFrameAnimation.keyTimes = @[@0, @0.4, @0.8, @0.9, @1.0];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddArcToPoint(path, NULL, 0, 200, 200, 200, 200);
    CGPathAddArcToPoint(path, NULL, 400, 200, 400, 0, 200);
    CGPathAddLineToPoint(path, NULL, 200, 300);
    CGPathCloseSubpath(path);
    keyFrameAnimation.path = path;
    
    CGPathRelease(path);
    
    [_imageView setAnimations:@{@"frameOrigin": keyFrameAnimation}];
    
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [[_imageView animator] setFrame:[_imageView frame]];
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
