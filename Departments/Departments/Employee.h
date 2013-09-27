//
//  Employee.h
//  Departments
//
//  Created by Sagar Natekar on 9/26/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Department;

@interface Employee : NSManagedObject

@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, retain) Department *department;
@property (nonatomic, readonly) NSString *fullName;

@end
