//
//  EquationToken.m
//  Graphique
//
//  Created by Sagar Natekar on 8/8/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "EquationToken.h"

@implementation EquationToken

@synthesize type;
@synthesize valid;
@synthesize value;

- (id) initWithType:(EquationTokenType)_type andValue:(NSString *)_value
{
    if (self = [super init]) {
        self.type = _type;
        self.value = _value;
        self.valid = (_type != EquationTokenTypeInvalid);
    }
    
    return self;
}


@end
