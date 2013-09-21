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
}

@property (nonatomic, strong) NSColor *bgColor;
@property (nonatomic, copy) NSString *string;

@end
