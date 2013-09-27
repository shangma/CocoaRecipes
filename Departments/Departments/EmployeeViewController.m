//
//  EmployeeViewController.m
//  Departments
//
//  Created by Sagar Natekar on 9/26/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import "EmployeeViewController.h"

@interface EmployeeViewController ()

@end

@implementation EmployeeViewController

- (id)init
{
    self = [super initWithNibName:@"EmployeeView" bundle:nil];
    if (self) {
        [self setTitle:@"Employees"];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)keyDown:(NSEvent *)theEvent
{
    [self interpretKeyEvents:@[theEvent]];
}

- (void)deleteBackward:(id)sender
{
    [employeeController remove:nil];
}
@end
