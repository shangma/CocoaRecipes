//
//  AppController.h
//  ViewSwapping
//
//  Created by Sagar Natekar on 8/26/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject

@property (weak) IBOutlet NSView *ourView;
@property (strong) NSViewController *ourViewController;

- (IBAction)changeView:(id)sender;
- (void) changeViewController:(NSInteger)tag;


@end
