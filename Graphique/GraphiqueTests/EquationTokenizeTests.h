//
//  EquationTokenizeTests.h
//  Graphique
//
//  Created by Sagar Natekar on 8/8/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "EquationToken.h"

@interface EquationTokenizeTests : SenTestCase

- (void) testSimple;
- (void) testExponent;
- (void) testExponentWithCaret;
- (void) testExponentWithParens;
- (void) testWhitespace;
- (void) testTrigFunctionsAndSymbols;
- (void) testParenthesisMatching;
- (void) testInvalid;
- (void) helperTestToken:(EquationToken *) token type:(EquationTokenType) type value:(NSString *)value;

@end
