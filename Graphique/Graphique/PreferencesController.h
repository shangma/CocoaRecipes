//
//  PreferencesController.h
//  Graphique
//
//  Created by Sagar Natekar on 8/21/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSWindowController
{
    NSButton *initialViewIsGraph;
}

@property (nonatomic, strong) IBOutlet NSButton *initialViewIsGraph;

- (IBAction)changeInitialView:(id)sender;

@end
