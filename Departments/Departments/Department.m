//
//  Department.m
//  Departments
//
//  Created by Sagar Natekar on 9/26/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import "Department.h"


@implementation Department

@dynamic deptName;
@dynamic employees;
@dynamic manager;

- (void) addEmployeesObject:(NSManagedObject *)value
{
    NSLog(@"Dept %@ adding employee %@", [self deptName], [(Employee *)value fullName]);
    
    NSSet *s = [NSSet setWithObject:value];
    
    [self willChangeValueForKey:@"employees" withSetMutation:NSKeyValueUnionSetMutation usingObjects:s];
    [[self primitiveValueForKey:@"employees"] addObject:value];
    [self didChangeValueForKey:@"employees" withSetMutation:NSKeyValueUnionSetMutation usingObjects:s];
    
}

- (void)removeEmployeesObject:(NSManagedObject *)value
{
    NSLog(@"Dept %@ removing employee %@", [self deptName], [(Employee *)value fullName]);
    Employee *mgr = (Employee *)[self manager];
    if (mgr == value) {
        [self setManager:nil];
    }
    
    NSSet *s = [NSSet setWithObject:value];
    
    [self willChangeValueForKey:@"employees" withSetMutation:NSKeyValueMinusSetMutation usingObjects:s];
    [[self primitiveValueForKey:@"employees"] removeObject:value];
    [self didChangeValueForKey:@"employees" withSetMutation:NSKeyValueMinusSetMutation usingObjects:s];
}

@end
