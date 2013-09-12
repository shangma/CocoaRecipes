//
//  RMDocument.h
//  RaiseMan
//
//  Created by Sagar Natekar on 7/21/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Person;

@interface RMDocument : NSDocument
{
    NSMutableArray *employees;
}

- (void) setEmployees:(NSMutableArray *)a;
- (void) insertObject:(Person *)p inEmployeesAtIndex:(NSUInteger) index;
- (void) removeObjectFromEmployeesAtIndex:(NSUInteger) index;

@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSArrayController *employeeController;

- (IBAction)removeEmployee:(id)sender;

@end
