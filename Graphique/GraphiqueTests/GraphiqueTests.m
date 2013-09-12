//
//  GraphiqueTests.m
//  GraphiqueTests
//
//  Created by Sagar Natekar on 8/5/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "GraphiqueTests.h"
#import "Equation.h"

@implementation GraphiqueTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void) testEquationValidation
{
    NSError *error = nil;
    Equation *equation = [[Equation alloc] initWithString:@"(3+4*7 / (3+4))"];
    if (![equation validate:&error]) {
        STFail(@"Equation should have been valid");
    }
}

- (void) testEquationValidationWithInvalidCharacters
{
    NSError *error = nil;
    Equation *equation = [[Equation alloc] initWithString:@"invalid characters"];
    if ([equation validate:&error]) {
        STFail(@"Equation should not have been valid");
    }
    
    if ([error code] != 100) {
        STFail(@"Validation should have failed with error code 100 instead of %d", [error code]);
    }
}

- (void) testEquationValidationWithConsecutiveOperators
{
    NSError *error = nil;
    Equation *equation = [[Equation alloc] initWithString:@"2++3"];
    if([equation validate:&error])
    {
        STFail(@"Equation should not have been valid");
    }
    if([error code] != 101)
    {
        STFail(@"Validation should have failed with code 101 instead of %d", [error code]);
    }
}

- (void) testEquationValidationWithTooManyOpenBrackets
{
    NSError *error = nil;
    Equation *equation = [[Equation alloc] initWithString:@"((4+3)"];
    if([equation validate:&error])
    {
        STFail(@"Equation should not have been valid");
    }
    if([error code] != 102)
    {
        STFail(@"Validation should have failed with code 102 instead of %d", [error code]);
    }
}

- (void) testEquationValidationWithTooManyCloseBrackets
{
    NSError *error = nil;
    Equation *equation = [[Equation alloc] initWithString:@"(4+3))"];
    if([equation validate:&error])
    {
        STFail(@"Equation should not have been valid");
    }
    if([error code] != 103)
    {
        STFail(@"Validation should have failed with code 103 instead of %d", [error code]);
    }
}

@end
