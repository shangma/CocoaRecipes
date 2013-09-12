//
//  TodoAppController.h
//  TodoList
//
//  Created by Sagar Natekar on 7/20/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoAppController : NSObject <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>
{
    NSMutableArray *items;
}

@property (assign) IBOutlet NSButton *addButton;
@property (assign) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSTextField *inputItemField;
@property (assign) IBOutlet NSButton *deleteButton;

@end
