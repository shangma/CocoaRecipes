//
//  MyDocument.h
//  Departments
//
//  Created by Sagar Natekar on 9/26/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ManagingViewController;

@interface MyDocument : NSPersistentDocument
{
    IBOutlet NSBox *box;
    IBOutlet NSPopUpButton *popUp;
    NSMutableArray *viewControllers;
}

- (IBAction)changeViewController:(id)sender;
- (void) displayViewController:(ManagingViewController *) vc;

@end
