//
//  TutorController.m
//  TypingTutor
//
//  Created by Sagar Natekar on 9/22/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "TutorController.h"
#import "BigLetterView.h"

@implementation TutorController

- (id) init
{
    if (self = [super init]) {
        letters = @[@"a",@"s",@"d",@"f",@"j",@"k",@"l",@";"];
        
        srandom((unsigned)time(NULL));
        timeLimit = 5.0;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self showAnotherLetter];
}

- (void)resetElapsedTime
{
    startTime = [NSDate timeIntervalSinceReferenceDate];
    [self updateElapsedTime];
}

- (void)updateElapsedTime
{
    [self willChangeValueForKey:@"elapsedTime"];
    elapsedTime = [NSDate timeIntervalSinceReferenceDate] - startTime;
    [self didChangeValueForKey:@"elapsedTime"];
}

- (void)showAnotherLetter
{
    int x = lastIndex;
    while (x == lastIndex) {
        x = (int)(random()%[letters count]);
    }
    
    lastIndex = x;
    [outLetterView setString:[letters objectAtIndex:x]];
    
    [self resetElapsedTime];
}

- (IBAction)stopGo:(id)sender
{
    [self resetElapsedTime];
    
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkThem:) userInfo:nil repeats:YES];
    }
    else
    {
        [timer invalidate];
        timer = nil;
    
    }
}

- (void) checkThem:(NSTimer *) timer
{
    if ([[inLetterView string] isEqualToString:[outLetterView string]]) {
        [self showAnotherLetter];
    }
    [self updateElapsedTime];
    
    if (elapsedTime >= timeLimit) {
        NSBeep();
        [self resetElapsedTime];
    }
}

- (IBAction)showSpeedSheet:(id)sender
{
    [NSApp beginSheet:speedSheet modalForWindow:[inLetterView window] modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
}

- (IBAction)endSpeedSheet:(id)sender
{
    [NSApp endSheet:speedSheet];
    [speedSheet orderOut:sender];
}


@end
