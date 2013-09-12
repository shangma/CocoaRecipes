//
//  Person.h
//  OutlineView
//
//  Created by Sagar Natekar on 9/2/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (readonly, copy) NSMutableArray *children;

- (id) initWithName:(NSString *) name age:(int) age;
- (void) addChild:(Person *)p;
- (void) removeChild:(Person *)p;

@end
