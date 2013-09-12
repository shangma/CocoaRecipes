//
//  TodoItem.h
//  TodoList
//
//  Created by Sagar Natekar on 7/21/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoItem : NSObject <NSCopying>
{
    NSString *itemValue;
}

@property (nonatomic, copy) NSString *itemValue;

@end
