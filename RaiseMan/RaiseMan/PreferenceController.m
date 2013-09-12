//
//  PreferenceController.m
//  RaiseMan
//
//  Created by Sagar Natekar on 8/12/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import "PreferenceController.h"

NSString *const BNRTableBgColorKey          = @"BNRTableBackgroundColor";
NSString *const BNREmptyDocKey              = @"BNREmptyDocumentFlag";
NSString *const BNRColorChangedNotification = @"BNRColorChanged";

@interface PreferenceController ()

@end

@implementation PreferenceController

- (id) init
{
    self = [super initWithWindowNibName:@"Preferences"];
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [colorWell setColor:[PreferenceController preferenceTableBgColor]];
    
    [checkBox setState:[PreferenceController preferenceEmptyDoc]];
}

+ (NSColor *) preferenceTableBgColor
{
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:BNRTableBgColorKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
}

+ (void) setPreferenceTableBgColor:(NSColor *)color
{
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:BNRTableBgColorKey];
}

+ (BOOL) preferenceEmptyDoc
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:BNREmptyDocKey];
}

+ (void) setPreferenceEmptyDoc:(BOOL)emptyDoc
{
    [[NSUserDefaults standardUserDefaults] setBool:emptyDoc forKey:BNREmptyDocKey];
}

- (IBAction)changeBackgroundColor:(id)sender
{
    NSColor *color = [colorWell color];
    [PreferenceController setPreferenceTableBgColor:color];
    
    NSDictionary *d = [NSDictionary dictionaryWithObject:color forKey:@"color"];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:BNRColorChangedNotification object:self userInfo:d];
    
}

- (IBAction)changeNewEmptyDoc:(id)sender
{
    NSInteger state = [checkBox state];
    [PreferenceController setPreferenceEmptyDoc:state];
}

@end
