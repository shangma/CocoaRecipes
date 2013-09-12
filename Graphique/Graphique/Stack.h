//
//  Stack.h
//  Graphique
//
//  Created by Sagar Natekar on 8/8/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Foundation/Foundation.h>

//Implements a stack for parentheses matching
@interface Stack : NSObject
{
    @private
    NSMutableArray *stack;
}

- (void) push:(id) obj;
- (id) pop;
- (BOOL) hasObjects;

@end
