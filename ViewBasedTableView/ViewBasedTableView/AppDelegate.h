//
//  AppDelegate.h
//  ViewBasedTableView
//
//  Created by Sagar Natekar on 9/8/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//Based on Apple Programming channel lessons 51-53
@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableView *tableView;

@end
