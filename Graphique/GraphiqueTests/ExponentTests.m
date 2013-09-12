//
//  ExponentTests.m
//  Graphique
//
//  Created by Sagar Natekar on 8/8/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "ExponentTests.h"
#import "Equation.h"
#import "EquationToken.h"

@implementation ExponentTests

- (void) testExponents
{
    Equation *equation = [[Equation alloc] initWithString:@"32x2+(x+7)45+3^3"];
    NSArray *tokens = equation.tokens;
    
    STAssertTrue(tokens.count == 14, NULL);
    
    EquationToken *token = nil;
    
    token = [tokens objectAtIndex:0];
    STAssertEquals(EquationTokenTypeNumber, token.type, NULL);
    STAssertEqualObjects(@"32", token.value, NULL);
    
    token = [tokens objectAtIndex:2];
    STAssertEquals(EquationTokenTypeExponent, token.type, NULL);
    STAssertEqualObjects(@"2", token.value, NULL);
    
    token = [tokens objectAtIndex:7];
    STAssertEquals(EquationTokenTypeNumber, token.type, NULL);
    STAssertEqualObjects(@"7", token.value, NULL);
    
    token = [tokens objectAtIndex:9];
    STAssertEquals(EquationTokenTypeExponent, token.type, NULL);
    STAssertEqualObjects(@"45", token.value, NULL);
    
    token = [tokens objectAtIndex:11];
    STAssertEquals(EquationTokenTypeNumber, token.type, NULL);
    STAssertEqualObjects(@"3", token.value, NULL);
    
    token = [tokens objectAtIndex:13];
    STAssertEquals(EquationTokenTypeExponent, token.type, NULL);
    STAssertEqualObjects(@"3", token.value, NULL);
    
}
@end
