//
//  AppController.h
//  CollectionView
//
//  Created by Sagar Natekar on 10/22/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject
{
    IBOutlet NSArrayController *arrayController;
}

@property (strong) NSMutableArray *students;

@end
