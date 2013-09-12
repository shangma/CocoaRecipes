//
//  AppController.m
//  RaiseMan
//
//  Created by Sagar Natekar on 8/12/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController

+ (void) initialize
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor yellowColor]];
    
    [defaultValues setObject:colorAsData forKey:BNRTableBgColorKey];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:BNREmptyDocKey];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    
    NSLog(@"Registered defaults : %@", defaultValues);
    
}

- (BOOL) applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    return [PreferenceController preferenceEmptyDoc];
}

- (IBAction)showPreferencePanel:(id)sender
{
    if (!preferenceController) {
        preferenceController = [[PreferenceController alloc] init];
    }
    [preferenceController showWindow:self];
    
}

@end
