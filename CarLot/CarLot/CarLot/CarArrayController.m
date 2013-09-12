//
//  CarArrayController.m
//  CarLot
//
//  Created by Sagar Natekar on 7/28/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import "CarArrayController.h"

@implementation CarArrayController

- (id) newObject
{
    id newObject = [super newObject];
    NSDate *now = [NSDate date];
    [newObject setValue:now forKey:@"datePurchased"];
    return newObject;
    
}

@end
