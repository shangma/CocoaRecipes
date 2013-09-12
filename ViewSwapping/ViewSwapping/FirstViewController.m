//
//  FirstViewController.m
//  ViewSwapping
//
//  Created by Sagar Natekar on 8/26/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize textField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (IBAction)changeText:(id)sender
{
    [textField setStringValue:@"Changed value"];
    
}

@end
