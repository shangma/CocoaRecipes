//
//  PreferencesController.m
//  Graphique
//
//  Created by Sagar Natekar on 8/21/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "PreferencesController.h"

@interface PreferencesController ()

@end

@implementation PreferencesController

@synthesize initialViewIsGraph;

- (id) init
{
    self = [super initWithWindowNibName:@"PreferencesController"];
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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [initialViewIsGraph setState:[userDefaults boolForKey:@"InitialViewIsGraph"]];
}

- (IBAction)changeInitialView:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:[initialViewIsGraph state] forKey:@"InitialViewIsGraph"];
}

@end
