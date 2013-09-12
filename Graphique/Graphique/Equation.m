//
//  Equation.m
//  Graphique
//
//  Created by Sagar Natekar on 8/7/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "Equation.h"
#import "EquationToken.h"
#import "Stack.h"

@interface Equation ()

- (BOOL) produceError:(NSError **)error withCode:(NSInteger) code andMessage:(NSString *) message;
- (void) tokenize;
- (EquationToken *)newTokenFromString:(NSString *) string;
- (NSString *) expand;

@end

static NSArray *OPERATORS;
static NSArray *TRIG_FUNCTIONS;
static NSArray *SYMBOLS;

@implementation Equation

@synthesize text;
@synthesize tokens;

+ (void) initialize
{
    OPERATORS = @[@"+", @"-", @"*", @"/", @"^"];
    TRIG_FUNCTIONS = @[@"sin", @"cos"];
    SYMBOLS = @[@"pi", @"π"]; //"Option+p" for pi symbol
}

- (id) initWithString:(NSString *)string
{
    if (self = [super init]) {
        self.text = string;
        self.tokens = [NSMutableArray array];
        [self tokenize];
    }
    
    return self;
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Equation [%@]", [self expand]];
}

- (float) evaluateForX:(float)x
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/awk"];
    
    NSArray *args = [NSArray arrayWithObjects:[NSString stringWithFormat:@"BEGIN { x=%f ; print %@ ; }", x, [self expand]], nil];
    
    [task setArguments:args];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    float value = [string floatValue];
    
    return value;
}

- (BOOL) validate:(NSError *__autoreleasing *)error
{
    // Validation rules
    // 1. Only digits, operators, variables, parentheses, trigonometric functions, and symbols(pi,π) allowed
    // 2. There should be the same amount of closing and opening parentheses
    // 3. no two consecutive operators
    
    NSString *allowed = @"x, 0-9, (), operators, trig functions, pi";
    EquationToken *prevToken = nil;
    
    for (EquationToken *token in self.tokens)
    {
        if (!token.valid)
        {
            if (token.type == EquationTokenTypeOpenParen)
            {
                return [self produceError:error withCode:102 andMessage:@"Too many open parentheses"];
            }
            else if (token.type == EquationTokenTypeCloseParen)
            {
                return [self produceError:error withCode:103 andMessage:@"Too many closed parentheses"];
            }
            else
            {
                return [self produceError:error withCode:100 andMessage:[NSString stringWithFormat:@"Invalid character typed. Only %@ are allowed", allowed]];
            }
        }
    
        if (token.type == EquationTokenTypeOperator && prevToken.type == EquationTokenTypeOperator)
        {
            return [self produceError:error withCode:101 andMessage:@"Consecutive operators are not allowed"];
        }
    
        prevToken = token;
    }

    return YES;
}

- (BOOL) produceError:(NSError **)error withCode:(NSInteger) code andMessage:(NSString *) message
{
    if (error != nil)
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        
        [errorDetail setValue:message forKey:NSLocalizedDescriptionKey];
        
        *error = [NSError errorWithDomain:@"Graphique" code:code userInfo:errorDetail];
        
    }
    
    return NO;
}

- (void) tokenize
{
    [tokens removeAllObjects];
    
    Stack *stack = [[Stack alloc] init];
    
    NSString *tempToken = @"";
    EquationToken *token = nil;
    
    for (NSUInteger i = 0, n = text.length; i < n; i++)
    {
        unichar c = [text characterAtIndex:i];
        tempToken = [tempToken stringByAppendingFormat:@"%C", c];
        
        //Keep all digits of a number as one token
        if (isdigit(c) || c == '.')
        {
            //Keep reading characters till end of string
            while (i < (n-1))
            {
                i++;
                c = [text characterAtIndex:i];
                if (isdigit(c) || c == '.')
                {
                    tempToken = [tempToken stringByAppendingFormat:@"%C",c];
                }
                else
                {
                    i--;
                    break;
                }
            }
        }
        
        //Keep all spaces together
        else if (c == ' ')
        {
            while (i < (n-1))
            {
                i++;
                c = [text characterAtIndex:i];
                if (c == ' ')
                {
                    tempToken = [tempToken stringByAppendingFormat:@"%C",c];
                }
                else
                {
                    i--;
                    break;
                }
            }
        }
        
        //Check for trignometric functions
        for (NSString *trig in TRIG_FUNCTIONS)
        {
            if (trig.length <= (n-i) && [trig isEqualToString:[[text substringWithRange:NSMakeRange(i, trig.length)] lowercaseString]])
            {
                tempToken = trig;
                i+= (trig.length - 1);
                break;
            }
        }
        
        //Check for symbols
        for (NSString *symbol in SYMBOLS)
        {
            if (symbol.length <= (n - i) && [symbol isEqualToString:[[text substringWithRange:NSMakeRange(i, symbol.length)] lowercaseString]])
            {
                tempToken = symbol;
                i += (symbol.length - 1);
                break;
            }
        }
        
        token = [self newTokenFromString:tempToken];
        
        //Recognize exponents in the token
        if (token.type == EquationTokenTypeNumber && tokens.count != 0)
        {
            EquationToken *prevToken = [tokens lastObject];
            
            if (prevToken.type == EquationTokenTypeVariable || prevToken.type == EquationTokenTypeCloseParen || [prevToken.value isEqualToString:@"^"])
            {
                token.type = EquationTokenTypeExponent;
            }
        }
        
        //Do parentheses matching using stack
        if (token.type == EquationTokenTypeOpenParen)
        {
            //Set the new open parenthesis to invalid as it is not yet matched and push it onto the stack
            token.valid = NO;
            [stack push:token];
        }
        else if (token.type == EquationTokenTypeCloseParen)
        {
            //Check for matching opening parenthesis
            if (![stack hasObjects]) {
                token.valid = NO;
            }
            else
            {
                EquationToken *match = [stack pop];
                match.valid = YES; //This was earlier set to NO when pushed on stack
            }
        }
        
        //Invalidate numbers with more than one decimal point
        if (token.type == EquationTokenTypeNumber && [[token.value componentsSeparatedByString:@"."] count] > 2)
        {
            token.valid = NO;
        }
        
        [tokens addObject:token];
        tempToken = @"";
    }
}

- (EquationToken *) newTokenFromString:(NSString *)string
{
    EquationTokenType type;
    string = [string lowercaseString];
    
    if ([OPERATORS containsObject:string])
    {
        type = EquationTokenTypeOperator;
    }
    else if ([TRIG_FUNCTIONS containsObject:string])
    {
        type = EquationTokenTypeTrigFunction;
    }
    else if ([SYMBOLS containsObject:string])
    {
        type = EquationTokenTypeSymbol;
    }
    else if ([string isEqualToString:@"("])
    {
        type = EquationTokenTypeOpenParen;
    }
    else if ([string isEqualToString:@")"])
    {
        type = EquationTokenTypeCloseParen;
    }
    else if ([string isEqualToString:@"x"])
    {
        type = EquationTokenTypeVariable;
    }
    //Digits are all grouped together in the tokenize: method, so just check the first character
    else if (isdigit([string characterAtIndex:0]) || [string characterAtIndex:0] == '.')
    {
        type = EquationTokenTypeNumber;
    }
    // Spaces are all grouped together in the tokenize: method, so just check the first character
    else if ([string characterAtIndex:0] == ' ')
    {
        type = EquationTokenTypeWhitespace;
    }
    else
    {
        type = EquationTokenTypeInvalid;
    }
    return [[EquationToken alloc] initWithType:type andValue:string];
}

//Function to add support for implicit exponents, multiplication and pi
- (NSString *) expand
{
    NSMutableString *expanded = [NSMutableString string];
    EquationToken *previousToken = nil;
    
    for (EquationToken *token in self.tokens)
    {
        // Get the value of the current token
        NSString *value = token.value;
        
        if (previousToken != nil)
        {
            // Do implicit exponents
            if (token.type == EquationTokenTypeExponent && ![previousToken.value isEqualToString:@"^"])
            {
                [expanded appendString:@"^"];
            }
            // Do implicit multiplication when token is an open parenthesis
            if (token.type == EquationTokenTypeOpenParen && (previousToken.type == EquationTokenTypeVariable || previousToken.type == EquationTokenTypeNumber))
            {
                [expanded appendString:@"*"];
            }
            // Do implicit multiplication when token is a variable or symbol
            if ((token.type == EquationTokenTypeVariable || token.type == EquationTokenTypeSymbol) && previousToken.type == EquationTokenTypeNumber)
            {
                [expanded appendString:@"*"];
            }
        }
        
        // Convert pi
        if ([value isEqualToString:@"pi"] || [value isEqualToString:@"π"])
        {
            value = [NSString stringWithFormat:@"%f", M_PI];
        }
        
        [expanded appendString:value];
        
        previousToken = token;
    }
    
    return expanded;
}

@end
