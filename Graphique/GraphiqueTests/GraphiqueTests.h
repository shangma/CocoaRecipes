//
//  GraphiqueTests.h
//  GraphiqueTests
//
//  Created by Sagar Natekar on 8/5/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface GraphiqueTests : SenTestCase

- (void) testEquationValidation;
- (void) testEquationValidationWithInvalidCharacters;
- (void) testEquationValidationWithConsecutiveOperators;
- (void) testEquationValidationWithTooManyOpenBrackets;
- (void) testEquationValidationWithTooManyCloseBrackets;

@end
