//
//  SpeakLineAppDelegate.m
//  SpeechSynthesizer
//
//  Created by Sagar Natekar on 7/19/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import "SpeakLineAppDelegate.h"

@implementation SpeakLineAppDelegate

- (void) awakeFromNib
{
    speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
    [speechSynth setDelegate:self];
    [_stopButton setEnabled:NO];
    [_speakButton setEnabled:YES];
    
    voices = [NSSpeechSynthesizer availableVoices];
    
    //When table view appears on screen, the default voice should be selected
    NSString *defaultVoice = [NSSpeechSynthesizer defaultVoice];
    NSInteger defaultRow = [voices indexOfObject:defaultVoice];
    NSIndexSet *indices = [NSIndexSet indexSetWithIndex:defaultRow];
    [_tableView selectRowIndexes:indices byExtendingSelection:NO];
    [_tableView scrollRowToVisible:defaultRow];
}

- (IBAction)sayIt:(id)sender
{
    NSString *str = [_textField stringValue];
    if ([str length] == 0)
    {
        NSLog(@"String from %@ is of zero length", _textField);
        return;
    }
    [speechSynth startSpeakingString:str];
    [_stopButton setEnabled:YES];
    [_speakButton setEnabled:NO];
    [_tableView setEnabled:NO];
}

- (IBAction)stopIt:(id)sender
{
    [speechSynth stopSpeaking];
}

- (void) speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking
{
    [_stopButton setEnabled:NO];
    [_speakButton setEnabled:YES];
    [_tableView setEnabled:YES];
}

//Data source methods for table view

- (NSInteger) numberOfRowsInTableView:(NSTableView *) tv
{
    return (NSInteger)[voices count];
}

- (id) tableView:(NSTableView *)tv
       objectValueForTableColumn:(NSTableColumn *)tableColumn
             row:(NSInteger)row
{
    NSString *v = [voices objectAtIndex:row];
    NSDictionary *dict = [NSSpeechSynthesizer attributesForVoice:v];
    return [dict objectForKey:NSVoiceName];
}

//Table view delegate methods

- (void) tableViewSelectionDidChange:(NSNotification *) notification
{
    NSInteger row = [_tableView selectedRow];
    if (row == -1) {
        return;
    }
    NSString *selectedVoice = [voices objectAtIndex:row];
    [speechSynth setVoice:selectedVoice];
    
    NSLog(@"New voice : %@", selectedVoice);
}

@end
