//
//  FirstViewController.h
//  ViewSwapping
//
//  Created by Sagar Natekar on 8/26/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FirstViewController : NSViewController

@property (weak) IBOutlet NSTextField *textField;

- (IBAction)changeText:(id)sender;

@end
