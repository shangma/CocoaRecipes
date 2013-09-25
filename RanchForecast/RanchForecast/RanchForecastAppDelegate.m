//
//  RanchForecastAppDelegate.m
//  RanchForecast
//
//  Created by Sagar Natekar on 9/24/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import "RanchForecastAppDelegate.h"
#import "ScheduleFetcher.h"
#import "ScheduledClass.h"

@implementation RanchForecastAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [tableView setTarget:self];
    [tableView setDoubleAction:@selector(openClass:)];
    
    ScheduleFetcher *fetcher = [[ScheduleFetcher alloc] init];
    NSError *error = nil;
    classes = [fetcher fetchClassesWithError:&error];
    
    [tableView reloadData];
}

- (void) openClass:(id) sender
{
    ScheduledClass *c = [classes objectAtIndex:[tableView clickedRow]];
    
    NSURL *baseURL = [NSURL URLWithString:@"http://www.bignerdranch.com/"];
    NSURL *url = [NSURL URLWithString:[c href] relativeToURL:baseURL];
    
    [[NSWorkspace sharedWorkspace] openURL:url];
}

#pragma mark NSTableViewDataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [classes count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    ScheduledClass *c = [classes objectAtIndex:row];
    return [c valueForKey:[tableColumn identifier]];
}

@end
