//
//  Department.h
//  Departments
//
//  Created by Sagar Natekar on 9/26/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Employee.h"

@interface Department : NSManagedObject

@property (nonatomic, retain) NSString * deptName;
@property (nonatomic, retain) NSSet *employees;
@property (nonatomic, retain) NSManagedObject *manager;
@end

@interface Department (CoreDataGeneratedAccessors)

- (void)addEmployeesObject:(NSManagedObject *)value;
- (void)removeEmployeesObject:(NSManagedObject *)value;
- (void)addEmployees:(NSSet *)values;
- (void)removeEmployees:(NSSet *)values;

@end
