//
//  WMRSSItem.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/28/13.
//
//

#import "WMRSSItem.h"

@implementation WMRSSItem

@synthesize  title, link, parentParserDelegate;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    isDate = NO;
    if ([elementName isEqual:@"title"]) {
        currentString = [[NSMutableString alloc] init];
        [self setTitle:currentString];
    } else if ([elementName isEqual:@"pubDate"]) {
        currentString = [[NSMutableString alloc] init];
        isDate = YES;
    } else if ([elementName isEqual:@"category"]) {
        currentString = [[NSMutableString alloc] init];
        [self setCategory:currentString];
    } else if ([elementName isEqual:@"description"]) {
        currentString = [[NSMutableString alloc] init];
        [self setAbout:currentString];
    } else if ([elementName isEqual:@"link"]) {
        currentString = [[NSMutableString alloc] init];
        [self setLink:currentString];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentString appendString:string];
    if (isDate) {
        NSString *removeDay = [currentString substringFromIndex:5];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss zzz"];
        NSDate *theDate = [dateFormatter dateFromString:removeDay];
        [self setEventDate:theDate];
    }

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    currentString = nil;
    if ([elementName isEqual:@"item"]) {
        [parser setDelegate:parentParserDelegate];
    }
}


@end
