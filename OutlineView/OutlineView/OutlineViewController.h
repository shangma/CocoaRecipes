//
//  OutlineViewController.h
//  OutlineView
//
//  Created by Sagar Natekar on 9/2/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface OutlineViewController : NSObject <NSOutlineViewDataSource>

@property (weak) IBOutlet NSOutlineView *outlineView;
@property (copy) NSMutableArray *people;

- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;

@end
