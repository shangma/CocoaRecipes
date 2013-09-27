//
//  Employee.m
//  Departments
//
//  Created by Sagar Natekar on 9/26/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import "Employee.h"
#import "Department.h"


@implementation Employee

@dynamic firstName;
@dynamic lastName;
@dynamic department;

- (NSString *)fullName
{
    NSString *first = [self firstName];
    NSString *last = [self lastName];
    if (!first) {
        return last;
    }
    if (!last) {
        return first;
    }
    
    return [NSString stringWithFormat:@"%@ %@", first, last];

}

+ (NSSet *)keyPathsForValuesAffectingFullName
{
    return [NSSet setWithObjects:@"firstName", @"lastName",nil];
}
@end
