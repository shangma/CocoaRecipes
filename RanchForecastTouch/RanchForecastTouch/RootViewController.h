//
//  RootViewController.h
//  RanchForecastTouch
//
//  Created by Sagar Natekar on 9/30/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *fetchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)fetchClasses:(id)sender;

@end
