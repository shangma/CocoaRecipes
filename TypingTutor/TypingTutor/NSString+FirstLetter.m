//
//  NSString+FirstLetter.m
//  TypingTutor
//
//  Created by Sagar Natekar on 9/22/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "NSString+FirstLetter.h"

@implementation NSString (FirstLetter)

- (NSString * ) firstLetter
{
    if ([self length] < 2) {
        return self;
    }
    
    NSRange r;
    r.location = 0;
    r.length = 1;
    return [self substringWithRange:r];
}

@end
