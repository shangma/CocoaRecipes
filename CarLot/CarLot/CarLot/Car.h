//
//  Car.h
//  CarLot
//
//  Created by Sagar Natekar on 7/28/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Car : NSManagedObject

@property (nonatomic, retain) NSNumber * condition;
@property (nonatomic, retain) NSDate * datePurchased;
@property (nonatomic, retain) NSString * makeModel;
@property (nonatomic, retain) NSNumber * onSpecial;
@property (nonatomic, retain) id photo;
@property (nonatomic, retain) NSDecimalNumber * price;

@end
