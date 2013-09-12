//
//  EquationTokenizeTests.m
//  Graphique
//
//  Created by Sagar Natekar on 8/8/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "EquationTokenizeTests.h"
#import "Equation.h"

@implementation EquationTokenizeTests

- (void) helperTestToken:(EquationToken *)token type:(EquationTokenType)type value:(NSString *)value
{
    STAssertEquals(token.type, type, NULL);
    STAssertEqualObjects(token.value, value, NULL);
}

- (void) testSimple
{
    Equation *equation = [[Equation alloc] initWithString:@"22*x-1"];
    NSArray *tokens = equation.tokens;
    STAssertTrue(tokens.count == 5, NULL);
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeNumber
                    value:@"22"];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeOperator
                    value:@"*"];
    [self helperTestToken:[tokens objectAtIndex:2] type:EquationTokenTypeVariable
                    value:@"x"];
    [self helperTestToken:[tokens objectAtIndex:3] type:EquationTokenTypeOperator
                    value:@"-"];
    [self helperTestToken:[tokens objectAtIndex:4] type:EquationTokenTypeNumber
                    value:@"1"];
}

- (void) testExponent
{
    Equation *equation = [[Equation alloc] initWithString:@"x2"];
    NSArray *tokens = equation.tokens;
    STAssertTrue(tokens.count == 2, NULL);
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeVariable
                    value:@"x"];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeExponent
                    value:@"2"];
}

- (void) testExponentWithCaret
{
    Equation *equation = [[Equation alloc] initWithString:@"x^2"];
    NSArray *tokens = equation.tokens;
    STAssertTrue(tokens.count == 3, NULL);
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeVariable
                    value:@"x"];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeOperator
                    value:@"^"];
    [self helperTestToken:[tokens objectAtIndex:2] type:EquationTokenTypeExponent
                    value:@"2"];
}

- (void)testExponentWithParens
{
    Equation *equation = [[Equation alloc] initWithString:@"(3x+7)2"];
    NSArray *tokens = equation.tokens;
    STAssertTrue(tokens.count == 7, NULL);
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeOpenParen
                    value:@"("];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeNumber
                    value:@"3"];
    [self helperTestToken:[tokens objectAtIndex:2] type:EquationTokenTypeVariable
                    value:@"x"];
    [self helperTestToken:[tokens objectAtIndex:3] type:EquationTokenTypeOperator
                    value:@"+"];
    [self helperTestToken:[tokens objectAtIndex:4] type:EquationTokenTypeNumber
                    value:@"7"];
    [self helperTestToken:[tokens objectAtIndex:5] type:EquationTokenTypeCloseParen
                    value:@")"];
    [self helperTestToken:[tokens objectAtIndex:6] type:EquationTokenTypeExponent
                    value:@"2"];
}

- (void) testWhitespace
{
    Equation *equation = [[Equation alloc] initWithString:@"x + 7"];
    NSArray *tokens = equation.tokens;
    STAssertTrue(tokens.count == 5, NULL);
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeVariable
                    value:@"x"];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeWhitespace
                    value:@" "];
    [self helperTestToken:[tokens objectAtIndex:2] type:EquationTokenTypeOperator
                    value:@"+"];
    [self helperTestToken:[tokens objectAtIndex:3] type:EquationTokenTypeWhitespace
                    value:@" "];
    [self helperTestToken:[tokens objectAtIndex:4] type:EquationTokenTypeNumber
                    value:@"7"];
}

- (void)testTrigFunctionsAndSymbols
{
    Equation *equation = [[Equation alloc]
                          initWithString:@"sin(0.3)+cos(3.3)+pi+π"];
    NSArray *tokens = equation.tokens;
    STAssertTrue(tokens.count == 13, NULL);
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeTrigFunction
                    value:@"sin"];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeOpenParen
                    value:@"("];
    [self helperTestToken:[tokens objectAtIndex:2] type:EquationTokenTypeNumber
                    value:@"0.3"];
    [self helperTestToken:[tokens objectAtIndex:3] type:EquationTokenTypeCloseParen
                    value:@")"];
    [self helperTestToken:[tokens objectAtIndex:4] type:EquationTokenTypeOperator
                    value:@"+"];
    [self helperTestToken:[tokens objectAtIndex:5] type:EquationTokenTypeTrigFunction
                    value:@"cos"];
    [self helperTestToken:[tokens objectAtIndex:6] type:EquationTokenTypeOpenParen
                    value:@"("];
    [self helperTestToken:[tokens objectAtIndex:7] type:EquationTokenTypeNumber
                    value:@"3.3"];
    [self helperTestToken:[tokens objectAtIndex:8] type:EquationTokenTypeCloseParen
                    value:@")"];
    [self helperTestToken:[tokens objectAtIndex:9] type:EquationTokenTypeOperator
                    value:@"+"];
    [self helperTestToken:[tokens objectAtIndex:10] type:EquationTokenTypeSymbol
                    value:@"pi"];
    [self helperTestToken:[tokens objectAtIndex:11] type:EquationTokenTypeOperator
                    value:@"+"];
    [self helperTestToken:[tokens objectAtIndex:12] type:EquationTokenTypeSymbol
                    value:@"π"];
}

- (void)testParenthesisMatching
{
    {
        Equation *equation = [[Equation alloc] initWithString:@"()"];
        NSArray *tokens = equation.tokens;
        STAssertTrue(tokens.count == 2, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:0]).valid, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:1]).valid, NULL);
    }
    {
        Equation *equation = [[Equation alloc] initWithString:@"(())"];
        NSArray *tokens = equation.tokens;
        STAssertTrue(tokens.count == 4, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:0]).valid, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:1]).valid, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:2]).valid, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:3]).valid, NULL);
    }
    {
        Equation *equation = [[Equation alloc] initWithString:@"()()"];
        NSArray *tokens = equation.tokens;
        STAssertTrue(tokens.count == 4, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:0]).valid, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:1]).valid, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:2]).valid, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:3]).valid, NULL);
    }
    {
        Equation *equation = [[Equation alloc] initWithString:@")("];
        NSArray *tokens = equation.tokens;
        STAssertTrue(tokens.count == 2, NULL);
        STAssertFalse(((EquationToken *)[tokens objectAtIndex:0]).valid, NULL);
        STAssertFalse(((EquationToken *)[tokens objectAtIndex:1]).valid, NULL);
    }
    {
        Equation *equation = [[Equation alloc] initWithString:@"())"];
        NSArray *tokens = equation.tokens;
        STAssertTrue(tokens.count == 3, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:0]).valid, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:1]).valid, NULL);
        STAssertFalse(((EquationToken *)[tokens objectAtIndex:2]).valid, NULL);
    }
    {
        Equation *equation = [[Equation alloc] initWithString:@"(()))("];
        NSArray *tokens = equation.tokens;
        STAssertTrue(tokens.count == 6, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:0]).valid, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:1]).valid, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:2]).valid, NULL);
        STAssertTrue(((EquationToken *)[tokens objectAtIndex:3]).valid, NULL);
        STAssertFalse(((EquationToken *)[tokens objectAtIndex:4]).valid, NULL);
        STAssertFalse(((EquationToken *)[tokens objectAtIndex:5]).valid, NULL);
    }
}

- (void)testInvalid
{
    Equation *equation = [[Equation alloc] initWithString:@"invalid0.3.3"];
    NSArray *tokens = equation.tokens;
    STAssertTrue(tokens.count == 8, NULL);
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeInvalid
                    value:@"i"];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeInvalid
                    value:@"n"];
    [self helperTestToken:[tokens objectAtIndex:2] type:EquationTokenTypeInvalid
                    value:@"v"];
    [self helperTestToken:[tokens objectAtIndex:3] type:EquationTokenTypeInvalid
                    value:@"a"];
    [self helperTestToken:[tokens objectAtIndex:4] type:EquationTokenTypeInvalid
                    value:@"l"];
    [self helperTestToken:[tokens objectAtIndex:5] type:EquationTokenTypeInvalid
                    value:@"i"];
    [self helperTestToken:[tokens objectAtIndex:6] type:EquationTokenTypeInvalid
                    value:@"d"];
    [self helperTestToken:[tokens objectAtIndex:7] type:EquationTokenTypeNumber
                    value:@"0.3.3"];
    STAssertFalse(((EquationToken *)[tokens objectAtIndex:7]).valid, NULL);
}
@end
