//
//  MoveView.m
//  CoreAnimation
//
//  Created by Sagar Natekar on 9/20/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "MoveView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MoveView {
    NSImageView *_imageView;
    NSRect _startFrame;
    NSRect _endFrame;
    BOOL isAtStart;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat width = NSWidth(frame);
        CGFloat height = NSHeight(frame);
        
        _startFrame = NSMakeRect(0, 0, width/2.5, height/2.5);
        _endFrame = NSMakeRect(width/2.0, 100, width/2.0, height/2.0);
        
        _imageView = [[NSImageView alloc] initWithFrame:_startFrame];
        [_imageView setImage:[NSImage imageNamed:@"me.png"]];
        [_imageView setImageScaling:NSImageScaleAxesIndependently];
        
        [self addSubview:_imageView];
        [_imageView setAnimations:@{@"frameOrigin": [self originAnimation],
                                    @"frameSize": [self sizeAnimation]}];
        
        isAtStart = YES;
    }
    
    return self;
}

- (CABasicAnimation *) sizeAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    CAMediaTimingFunction *timing = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [animation setTimingFunction:timing];
    [animation setDuration:2.5f];
    [animation setFromValue:[NSValue valueWithSize:_startFrame.size]];
    [animation setToValue:[NSValue valueWithSize:_endFrame.size]];
    return animation;
}

- (CABasicAnimation *) originAnimation
{
    CABasicAnimation *originAnim = [CABasicAnimation animation];
    [originAnim setDuration:4.0f];
    NSPoint startPoint = _startFrame.origin;
    NSPoint endPoint = _endFrame.origin;
    [originAnim setFromValue:[NSValue valueWithPoint:startPoint]];
    [originAnim setToValue:[NSValue valueWithPoint:endPoint]];
    return originAnim;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if ([self inLiveResize]) {
        CGFloat width = NSWidth(self.frame);
        CGFloat height = NSHeight(self.frame);
        
        _startFrame = NSMakeRect(0, 0, width/2.5, height/2.5);
        _endFrame = NSMakeRect(width/2.0, 100, width/2.0, height/2.0);
        
        if (isAtStart) {
            [_imageView setFrame:_startFrame];
        }
        else
        {
            [_imageView setFrame:_endFrame];
        }
    }
    
}

- (BOOL) acceptsFirstResponder
{
    return YES;
}

- (void) keyDown:(NSEvent *)theEvent
{
    if (isAtStart) {
        [[_imageView animator] setFrame:_endFrame];
        [[_imageView animator] setAlphaValue:0.25];
        isAtStart = NO;
    }
    else
    {
        [[_imageView animator] setFrame:_startFrame];
        [[_imageView animator] setAlphaValue:1.0];
        isAtStart = YES;
    }

}


@end
