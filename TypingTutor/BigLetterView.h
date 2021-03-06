//
//  BigLetterView.h
//  TypingTutor
//
//  Created by Sagar Natekar on 9/21/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BigLetterView : NSView
{
    NSColor *bgColor;
    NSString *string;
    NSMutableDictionary *attributes;
    NSEvent *mouseDownEvent;
    BOOL highlighted;
}

@property (nonatomic, strong) NSColor *bgColor;
@property (nonatomic, copy) NSString *string;

- (void) prepareAttributes;
- (IBAction)savePDF:(id)sender;

- (IBAction)cut:(id)sender;
- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;

@end
