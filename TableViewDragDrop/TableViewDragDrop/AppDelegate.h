//
//  AppDelegate.h
//  TableViewDragDrop
//
//  Created by Sagar Natekar on 9/11/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//Based on Apple programming channel lessons 55-56
@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;

@property (assign) IBOutlet NSWindow *window;

@end
