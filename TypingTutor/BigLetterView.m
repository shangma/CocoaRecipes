//
//  BigLetterView.m
//  TypingTutor
//
//  Created by Sagar Natekar on 9/21/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "BigLetterView.h"
#import "NSString+FirstLetter.h"

@implementation BigLetterView

@synthesize bgColor = bgColor;
@synthesize string = string;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSLog(@"initializing view");
        [self prepareAttributes];
        bgColor = [NSColor yellowColor];
        string = @"";
        [self registerForDraggedTypes:@[NSPasteboardTypeString]];
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
    [self setNeedsDisplay:YES];
}

- (NSString *) string
{
    return string;
}

- (void) drawStringCenteredIn:(NSRect) r
{
    NSSize strSize = [string sizeWithAttributes:attributes];
    NSPoint strOrigin;
    strOrigin.x = r.origin.x + (r.size.width - strSize.width)/2;
    strOrigin.y = r.origin.y + (r.size.height - strSize.height)/2;
    [string drawAtPoint:strOrigin withAttributes:attributes];
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = [self bounds];
    
    if (highlighted) {
        NSGradient *gr;
        gr = [[NSGradient alloc] initWithStartingColor:[NSColor whiteColor] endingColor:bgColor];
        [gr drawInRect:bounds relativeCenterPosition:NSZeroPoint];
    }
    else
    {
        [bgColor set];
        [NSBezierPath fillRect:bounds];
    }
    
    [self drawStringCenteredIn:bounds];
    
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

- (void) prepareAttributes
{
    attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[NSFont userFontOfSize:75] forKey:NSFontAttributeName];
    [attributes setObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
}

- (IBAction)savePDF:(id)sender
{
    __block NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"pdf"]];
    
    [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            NSRect r = [self bounds];
            NSData *data = [self dataWithPDFInsideRect:r];
            NSError *error;
            BOOL successful = [data writeToURL:[panel URL] options:0 error:&error];
            if (!successful) {
                NSAlert *a = [NSAlert alertWithError:error];
                [a runModal];
            }
        }
        panel = nil;
    }];
}

- (void) writeToPasteboard:(NSPasteboard *) pb
{
    [pb clearContents];
    [pb writeObjects:@[string]];
}

- (BOOL) readFromPasteboard:(NSPasteboard *) pb
{
    NSArray *classes = @[[NSString class]];
    NSArray *objects = [pb readObjectsForClasses:classes options:nil];
    
    if ([objects count] > 0) {
        NSString *value = [objects objectAtIndex:0];
        
        [self setString:[value firstLetter]];
        return YES;

    }
    
    return NO;
}


- (IBAction)cut:(id)sender
{
    [self copy:sender];
    [self setString:@""];
}

- (IBAction)copy:(id)sender
{
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [self writeToPasteboard:pb];
}

- (IBAction)paste:(id)sender
{
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    if (![self readFromPasteboard:pb]) {
        NSBeep();
    }
}

- (NSDragOperation) draggingSourceOperationMaskForLocal:(BOOL)flag
{
    return NSDragOperationCopy | NSDragOperationDelete;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    mouseDownEvent = theEvent;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint down = [mouseDownEvent locationInWindow];
    NSPoint drag = [theEvent locationInWindow];
    float distance = hypot(down.x - drag.x, down.y - drag.y);
    if (distance < 3) {
        return;
    }
    
    if ([string length] == 0) {
        return;
    }
    
    NSSize s = [string sizeWithAttributes:attributes];
    
    NSImage *image = [[NSImage alloc] initWithSize:s];
    
    NSRect imageBounds;
    imageBounds.origin = NSZeroPoint;
    imageBounds.size = s;
    
    [image lockFocus];
    [self drawStringCenteredIn:imageBounds];
    [image unlockFocus];
    
    NSPoint p = [self convertPoint:down fromView:nil];
    
    p.x = p.x - s.width/2;
    p.y = p.y - s.height/2;
    
    NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSDragPboard];
    
    [self writeToPasteboard:pb];
    
    [self dragImage:image
                 at:p
             offset:NSZeroSize
              event:mouseDownEvent
         pasteboard:pb
             source:self
          slideBack:YES];
}

- (void)draggedImage:(NSImage *)image endedAt:(NSPoint)screenPoint operation:(NSDragOperation)operation
{
    if (operation == NSDragOperationDelete) {
        [self setString:@""];
    }
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSLog(@"draggingEntered:");
    if ([sender draggingSource] == self) {
        return NSDragOperationNone;
    }
    
    highlighted = YES;
    [self setNeedsDisplay:YES];
    return NSDragOperationCopy;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    NSLog(@"draggingExited:");
    highlighted = NO;
    [self setNeedsDisplay:YES];
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    NSDragOperation op = [sender draggingSourceOperationMask];
    NSLog(@"Operation mask : %ld", op);
    if ([sender draggingSource] == self) {
        return NSDragOperationNone;
    }
    
    return NSDragOperationCopy;
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pb = [sender draggingPasteboard];
    if (![self readFromPasteboard:pb]) {
        NSLog(@"Error: Could not read from dragging pasteboard");
        return NO;
    }
    
    return YES;
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    NSLog(@"concludeDragOperation:");
    highlighted = YES;
    [self setNeedsDisplay:YES];
}

@end
