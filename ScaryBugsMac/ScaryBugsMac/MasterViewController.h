//
//  MasterViewController.h
//  ScaryBugsMac
//
//  Created by Sagar Natekar on 7/23/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDStarRating.h"

@interface MasterViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, EDStarRatingProtocol>

@property (nonatomic, strong) NSMutableArray *bugs;

@end
