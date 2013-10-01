//
//  RootViewController.m
//  RanchForecastTouch
//
//  Created by Sagar Natekar on 9/30/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import "RootViewController.h"
#import "ScheduleFetcher.h"
#import "ScheduleViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setTitle:@"Ranch Forecast"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fetchClasses:(id)sender {
    
    [_activityIndicator startAnimating];
    [_fetchButton setEnabled:NO];
    
    ScheduleFetcher *fetcher = [[ScheduleFetcher alloc] init];
    [fetcher fetchClassesWithBlock:^(NSArray *classes, NSError *error) {

        [_fetchButton setEnabled:YES];
        [_activityIndicator stopAnimating];
        
        if (classes) {
            ScheduleViewController *svc = [[ScheduleViewController alloc] initWithStyle:UITableViewStylePlain];
            [svc setClasses:classes];
            [self.navigationController pushViewController:svc animated:YES];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error fetching classes"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    
}
@end
