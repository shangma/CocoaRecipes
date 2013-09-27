//
//  DepartmentViewController.m
//  Departments
//
//  Created by Sagar Natekar on 9/26/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import "DepartmentViewController.h"

@interface DepartmentViewController ()

@end

@implementation DepartmentViewController

- (id)init
{
    self = [super initWithNibName:@"DepartmentView" bundle:nil];
    if (self) {
        [self setTitle:@"Departments"];
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

@end
