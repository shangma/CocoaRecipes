//
//  ManagingViewController.h
//  Departments
//
//  Created by Sagar Natekar on 9/26/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ManagingViewController : NSViewController
{
    NSManagedObjectContext *managedObjectContext;
}

@property (strong) NSManagedObjectContext *managedObjectContext;

@end
