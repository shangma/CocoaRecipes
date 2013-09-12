//
//  Person.h
//  RaiseMan
//
//  Created by Sagar Natekar on 7/21/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>
{
    NSString *personName;
    float expectedRaise;
}

@property (nonatomic, copy) NSString *personName;
@property (nonatomic, assign) float expectedRaise;

@end
