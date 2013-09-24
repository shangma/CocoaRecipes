//
//  ColorFormatter.m
//  TypingTutor
//
//  Created by Sagar Natekar on 9/23/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "ColorFormatter.h"

@interface ColorFormatter ()

- (NSString *) firstColorKeyForPartialString:(NSString *) string;

@end

@implementation ColorFormatter

- (id) init
{
    if (self = [super init])
    {
        colorList = [NSColorList colorListNamed:@"Apple"];
    }
    
    return self;
}

- (NSString *)firstColorKeyForPartialString:(NSString *)string
{
    if ([string length] == 0) {
        return nil;
    }
    
    //Loop through color list
    for (NSString *key in [colorList allKeys]) {
        NSRange whereFound = [key rangeOfString:string options:NSCaseInsensitiveSearch];
        
        if (whereFound.location == 0 && whereFound.length > 0) {
            return key;
        }
    }
    
    return nil;
}

//Following three are overriden from NSFormatter
- (NSString *)stringForObjectValue:(id)obj
{
    if (![obj isKindOfClass:[NSColor class]]) {
        return nil;
    }
    
    //Convert to RGB color space
    NSColor *color;
    color = [obj colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    
    //Get components
    CGFloat red, green, blue;
    
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    
    float minDistance = 3.0;
    NSString *closestKey = nil;
    
    for (NSString *key in [colorList allKeys]) {
        NSColor *c = [colorList colorWithKey:key];
        CGFloat r,g,b;
        [c getRed:&r green:&g blue:&b alpha:NULL];
        
        float dist;
        dist = pow(red - r, 2) + pow(green - g, 2) + pow(blue - b, 2);
        
        if (dist < minDistance) {
            minDistance = dist;
            closestKey = key;
        }
    }
    
    return closestKey;
    
}

- (BOOL) getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    //Look up the value for 'string'
    NSString *matchingKey = [self firstColorKeyForPartialString:string];
    
    if (matchingKey) {
        *obj = [colorList colorWithKey:matchingKey];
        return YES;
    }
    else
    {
        if (error != NULL) {
            *error = [NSString stringWithFormat:@"%@ is not a color", string];
        }
        
        return NO;
    }
}

- (BOOL)isPartialStringValid:(NSString *__autoreleasing *)partialStringPtr
       proposedSelectedRange:(NSRangePointer)proposedSelRangePtr
              originalString:(NSString *)origString
       originalSelectedRange:(NSRange)origSelRange
            errorDescription:(NSString *__autoreleasing *)error
{
    if ([*partialStringPtr length] == 0) {
        return YES;
    }
    
    NSString *match = [self firstColorKeyForPartialString:*partialStringPtr];
    
    if (!match) {
        return NO;
    }
    
    if (origSelRange.location == proposedSelRangePtr->location) {
        return YES;
    }
    
    //If partial string is shorter than the match, provide the match and set the selection
    
    if ([match length] != [*partialStringPtr length])
    {
        proposedSelRangePtr->location = [*partialStringPtr length];
        proposedSelRangePtr->length = [match length] - proposedSelRangePtr->location;
        *partialStringPtr = match;
        return NO;
    }
    
    return YES;
}

@end
