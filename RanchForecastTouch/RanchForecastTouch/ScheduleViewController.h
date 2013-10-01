//
//  ScheduleViewController.h
//  RanchForecastTouch
//
//  Created by Sagar Natekar on 9/30/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleViewController : UITableViewController
{
    NSArray *classes;
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, strong) NSArray *classes;

@end
