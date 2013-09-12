//
//  EquationToken.h
//  Graphique
//
//  Created by Sagar Natekar on 8/8/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    EquationTokenTypeInvalid = 0,
    EquationTokenTypeNumber,
    EquationTokenTypeVariable,
    EquationTokenTypeOperator,
    EquationTokenTypeOpenParen,
    EquationTokenTypeCloseParen,
    EquationTokenTypeExponent,
    EquationTokenTypeSymbol,
    EquationTokenTypeTrigFunction,
    EquationTokenTypeWhitespace
} EquationTokenType;

@interface EquationToken : NSObject

@property (nonatomic) EquationTokenType type;
@property (nonatomic, strong) NSString *value;
@property (nonatomic) BOOL valid;

- (id)initWithType:(EquationTokenType)type
          andValue:(NSString *)value;

@end
