//
//  Equation.h
//  Graphique
//
//  Created by Sagar Natekar on 8/7/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Equation : NSObject
{
    @private
    NSString *text;
    
}

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSMutableArray *tokens;

- (id) initWithString:(NSString *) string;
- (float) evaluateForX:(float) x;
- (BOOL) validate:(NSError **) error;

@end
