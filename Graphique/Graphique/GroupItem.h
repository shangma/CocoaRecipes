//
//  GroupItem.h
//  Graphique
//
//  Created by Sagar Natekar on 8/6/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupItem : NSObject
{
    @private
    NSString *name;
    NSMutableArray *children;
    BOOL loaded;
}

@property (nonatomic, strong) NSString *name;
@property BOOL loaded;

- (NSInteger) numberOfChildren;
- (id) childAtIndex:(NSUInteger)n;
- (NSString *)text;
- (void) addChild:(id) childNode;
- (void) reset;

@end
