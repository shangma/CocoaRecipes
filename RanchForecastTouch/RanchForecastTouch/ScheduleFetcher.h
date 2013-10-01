//
//  ScheduleFetcher.h
//  RanchForecast
//
//  Created by Sagar Natekar on 9/24/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ScheduleFetcherResultBlock)(NSArray *classes, NSError *error);

@interface ScheduleFetcher : NSObject <NSXMLParserDelegate, NSURLConnectionDataDelegate>
{
    NSMutableArray *classes;
    NSMutableString *currentString;
    NSMutableDictionary *currentFields;
    NSDateFormatter *dateFormatter;
    
    ScheduleFetcherResultBlock resultBlock;
    NSMutableData *responseData;
    NSURLConnection *connection;
}

//- (NSArray *) fetchClassesWithError:(NSError **) outError;

- (void) fetchClassesWithBlock:(ScheduleFetcherResultBlock) theBlock;

@end
