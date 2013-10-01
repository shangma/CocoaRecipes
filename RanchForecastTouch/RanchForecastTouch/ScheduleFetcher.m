//
//  ScheduleFetcher.m
//  RanchForecast
//
//  Created by Sagar Natekar on 9/24/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import "ScheduleFetcher.h"
#import "ScheduledClass.h"

@implementation ScheduleFetcher

- (id)init
{
    if (self = [super init]) {
        classes = [[NSMutableArray alloc] init];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzzz"];
    }
    
    return self;
}

- (void) cleanUp
{
    responseData = nil;
    connection = nil;
    resultBlock = nil;
    
}

- (void)fetchClassesWithBlock:(ScheduleFetcherResultBlock)theBlock
{
    resultBlock = [theBlock copy];
    
    NSURL *xmlURL = [NSURL URLWithString:@"http://bignerdranch.com/xml/schedule"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:xmlURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (connection) {
        responseData = [[NSMutableData alloc] init];
    }
}

#pragma mark NSURLConnectionDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [classes removeAllObjects];
    
    NSXMLParser *parser;
    parser = [[NSXMLParser alloc] initWithData:responseData];
    [parser setDelegate:self];
    
    BOOL success = [parser parse];
    if (!success) {
        resultBlock(nil, [parser parserError]);
    }
    else
    {
        NSArray *output = [classes copy];
        resultBlock(output, nil);
    }

    [self cleanUp];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    resultBlock(nil, error);
    [self cleanUp];
}

#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"class"]) {
        currentFields = [[NSMutableDictionary alloc] init];
    }
    else if ([elementName isEqualToString:@"offering"])
    {
        [currentFields setObject:[attributeDict objectForKey:@"href"] forKey:@"href"];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!currentString) {
        currentString = [[NSMutableString alloc] init];
    }
    [currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"class"])
    {
        ScheduledClass *currentClass = [[ScheduledClass alloc] init];
        
        [currentClass setName:[currentFields objectForKey:@"offering"]];
        [currentClass setLocation:[currentFields objectForKey:@"location"]];
        [currentClass setHref:[currentFields objectForKey:@"href"]];
        
        NSString *beginString = [currentFields objectForKey:@"begin"];
        NSDate *beginDate = [dateFormatter dateFromString:beginString];
        [currentClass setBegin:beginDate];
        
        [classes addObject:currentClass];
        currentClass = nil;
        
        currentFields = nil;
    }
    else if (currentFields && currentString)
    {
        NSString *trimmed = [currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [currentFields setObject:trimmed forKey:elementName];
    }
    
    currentString = nil;
}

@end
