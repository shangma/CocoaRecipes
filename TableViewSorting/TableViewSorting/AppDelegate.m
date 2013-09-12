//
//  AppDelegate.m
//  TableViewSorting
//
//  Created by Sagar Natekar on 8/28/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate {
    
    NSPredicate *_searchPredicate;
}

- (id) init
{
    if (self = [super init]) {
        _people = [[NSMutableArray alloc] init];
        _searchPredicate = [NSPredicate predicateWithFormat:@"(name contains[cd] $value or (age == $value.intValue)"];
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_tableView setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)], [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]]];
    
    
}


//An alternate way of searching... the search field already has appropriate bindings set for "search"
- (IBAction)changePredicate:(id)sender
{
    NSString *str = [sender stringValue];
    NSPredicate *predicate = nil;
    if (![str isEqualToString:@""]) {
        NSDictionary *dictionary = @{@"value": str};
        predicate = [_searchPredicate predicateWithSubstitutionVariables:dictionary]; //Substitute $value with str
    }
    [_arrayController setFilterPredicate:predicate];
}

@end
