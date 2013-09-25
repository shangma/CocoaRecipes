//
//  ScheduleFetcher.h
//  RanchForecast
//
//  Created by Sagar Natekar on 9/24/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleFetcher : NSObject <NSXMLParserDelegate>
{
    NSMutableArray *classes;
    NSMutableString *currentString;
    NSMutableDictionary *currentFields;
    NSDateFormatter *dateFormatter;
}

- (NSArray *) fetchClassesWithError:(NSError **) outError;

@end
