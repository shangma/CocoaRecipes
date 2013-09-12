//
//  ScaryBugData.h
//  ScaryBugsMac
//
//  Created by Sagar Natekar on 7/23/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaryBugData : NSObject

@property (nonatomic, copy) NSString *title;
@property (assign) float rating;

- (id) initWithTitle:(NSString *) title rating:(float) rating;

@end
