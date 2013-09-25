//
//  RanchForecastAppDelegate.h
//  RanchForecast
//
//  Created by Sagar Natekar on 9/24/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RanchForecastAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource>
{
    IBOutlet NSTableView *tableView;
    NSArray *classes;
}

@property (assign) IBOutlet NSWindow *window;

@end
