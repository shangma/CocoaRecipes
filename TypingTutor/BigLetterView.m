//
//  BigLetterView.m
//  TypingTutor
//
//  Created by Sagar Natekar on 9/21/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "BigLetterView.h"

@implementation BigLetterView

@synthesize bgColor = bgColor;
@synthesize string = string;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSLog(@"initializing view");
        bgColor = [NSColor yellowColor];
        string = @"";
    }
    
    return self;
}

- (void) setBgColor:(NSColor *)color
{
    bgColor = color;
    [self setNeedsDisplay:YES];
}

- (NSColor *) bgColor
{
    return bgColor;
}

- (void)setString:(NSString *)_string
{
    string = _string;
    NSLog(@"The string is now %@", string);
}

- (NSString *) string
{
    return string;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = [self bounds];
    [bgColor set];
    [NSBezierPath fillRect:bounds];
    
    if ([[self window] firstResponder] == self && [NSGraphicsContext currentContextDrawingToScreen])
    {
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle(NSFocusRingOnly);
        [NSBezierPath fillRect:bounds];
        [NSGraphicsContext restoreGraphicsState];
        [[NSColor keyboardFocusIndicatorColor] set];
        [NSBezierPath setDefaultLineWidth:4.0];
        [NSBezierPath strokeRect:bounds];
    }
}

- (BOOL) isOpaque
{
    return YES;
}

- (BOOL) acceptsFirstResponder
{
    NSLog(@"Accepting");
    return YES;
}

- (BOOL) resignFirstResponder
{
    NSLog(@"Resigning");
    [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
    return YES;
}

- (BOOL) becomeFirstResponder
{
    NSLog(@"Becoming");
    [self setNeedsDisplay:YES];
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent
{
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)insertText:(id)insertString
{
    //Set string to be what the user typed
    [self setString:insertString];
}

- (void)insertTab:(id)sender
{
    [[self window] selectKeyViewFollowingView:self];
}

- (void)insertBacktab:(id)sender
{
    [[self window] selectKeyViewPrecedingView:self];
}

- (void)deleteBackward:(id)sender
{
    [self setString:@""];
}


@end
