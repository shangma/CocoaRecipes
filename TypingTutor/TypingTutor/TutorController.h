//
//  TutorController.h
//  TypingTutor
//
//  Created by Sagar Natekar on 9/22/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BigLetterView;

@interface TutorController : NSObject
{
    IBOutlet BigLetterView *inLetterView;
    IBOutlet BigLetterView *outLetterView;
    IBOutlet NSWindow *speedSheet;
    
    NSArray *letters;
    int lastIndex;
    
    NSTimeInterval startTime;
    NSTimeInterval elapsedTime;
    NSTimeInterval timeLimit;
    NSTimer *timer;
}

- (IBAction)stopGo:(id)sender;
- (IBAction)showSpeedSheet:(id)sender;
- (IBAction)endSpeedSheet:(id)sender;

- (void) updateElapsedTime;
- (void) resetElapsedTime;
- (void) showAnotherLetter;


@end
