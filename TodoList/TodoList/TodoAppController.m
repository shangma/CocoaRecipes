//
//  TodoAppController.m
//  TodoList
//
//  Created by Sagar Natekar on 7/20/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import "TodoAppController.h"
#import "TodoItem.h"

@interface TodoAppController ()

@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation TodoAppController

- (void) awakeFromNib
{
    items = [[NSMutableArray alloc] init];
    [_inputItemField setDelegate:self];
    [_addButton setEnabled:NO];
    [_deleteButton setEnabled:NO];
}

- (void)dealloc
{
    [items removeAllObjects];
    [items release];
    [super dealloc];
}

- (IBAction)addItem:(id)sender
{
    TodoItem *item = [[TodoItem alloc] init];
    item.itemValue = [_inputItemField stringValue];
    if ([[_inputItemField stringValue] isEqualToString:@""]) {
        item.itemValue = @"Adding default item. <You may edit this item now>.";
    }
    [_inputItemField setStringValue:@""];
    [items addObject:item];
    NSInteger defaultRow = [items count] - 1;
    NSIndexSet *indices = [NSIndexSet indexSetWithIndex:defaultRow];
    [_tableView reloadData];
    [_tableView selectRowIndexes:indices byExtendingSelection:NO];
    [_tableView scrollRowToVisible:[items count] - 1];
    [_addButton setEnabled:NO];
    [_deleteButton setEnabled:YES];
}

- (IBAction)deleteItem:(id)sender
{
    [items removeObjectAtIndex:_selectedRow];
    NSInteger defaultRow = [items count] - 1;
    NSIndexSet *indices = [NSIndexSet indexSetWithIndex:defaultRow];
    [_tableView reloadData];
    [_tableView selectRowIndexes:indices byExtendingSelection:NO];
    [_tableView scrollRowToVisible:[items count] - 1];
    if ([items count] == 0)
    {
        [_deleteButton setEnabled:NO];
    }
}

#pragma mark NSTableViewDataSource methods

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tv
{
    return (NSInteger)[items count];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [[items objectAtIndex:row] itemValue];
}

- (void) tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    [items replaceObjectAtIndex:row withObject:[(TodoItem *)object itemValue]];
}

- (void) tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    //Objects in the backing store - "items" need to adopt NSCopying protocol to support sorting
    [items sortUsingDescriptors:[tableView sortDescriptors]];
    [tableView reloadData];
}

#pragma mark NSTableViewDelegate methods

- (void) tableViewSelectionDidChange:(NSNotification *)notification
{
    _selectedRow = [_tableView selectedRow];
}

#pragma mark NSTextFieldDelegate methods

- (void) controlTextDidBeginEditing:(NSNotification *)obj
{
    [_addButton setEnabled:YES];
}

@end
