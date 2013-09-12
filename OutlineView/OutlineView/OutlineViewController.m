//
//  OutlineViewController.m
//  OutlineView
//
//  Created by Sagar Natekar on 9/2/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "OutlineViewController.h"

@implementation OutlineViewController

- (id) init
{
    if (self = [super init]) {
        _people = [[NSMutableArray alloc] init];
        Person *boss = [[Person alloc] initWithName:@"Yoda" age:900];
        [boss addChild:[[Person alloc] initWithName:@"Stephan" age:20]];
        [boss addChild:[[Person alloc] initWithName:@"Taylor" age:19]];
        [boss addChild:[[Person alloc] initWithName:@"Jesse" age:18]];
        
        [(Person *)[boss.children objectAtIndex:0] addChild:[[Person alloc] initWithName:@"Lucas" age:18]];
        
        [_people addObject:boss];
    }
    
    return self;
}

- (IBAction)add:(id)sender
{
    //Get the selected row/item in the view
    Person *p = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
    
    if (p) {
        [p addChild:[[Person alloc] init]];
    }
    else
    {
        //If nothing is selected, add item to the top level
        [self.people addObject:[[Person alloc] init]];
    }
    
    [self.outlineView reloadData];
}

- (IBAction)remove:(id)sender
{
    Person *p = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
    Person *parent = [self.outlineView parentForItem:p];
    
    if (parent) {
        [parent removeChild:p];
    }
    else if (p)
    {
        [self.people removeObject:p];
    }
    
    [self.outlineView reloadData];
}

#pragma mark NSOutlineView Data Source methods

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return !item ? [self.people count] : [[item children] count];
    
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return !item ? NO : [[item children] count] > 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    return !item ? [self.people objectAtIndex:index] : [[item children] objectAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if ([[tableColumn identifier] isEqualToString:@"name"])
    {
        return [item name];
    }
    else if ([[tableColumn identifier] isEqualToString:@"age"])
    {
        return @([item age]);
    }
    
    return @"Nobody here";
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if ([[tableColumn identifier] isEqualToString:@"name"]) {
        [(Person *)item setName:object];
    }
    
    if ([[tableColumn identifier] isEqualToString:@"age"]) {
        [item setAge:[object intValue]];
    }
}

@end
