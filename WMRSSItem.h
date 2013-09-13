//
//  WMRSSItem.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/28/13.
//
//

#import <Foundation/Foundation.h>

@interface WMRSSItem : NSObject <NSXMLParserDelegate>
{
    NSMutableString *currentString;
    BOOL isDate;
}
@property (nonatomic, unsafe_unretained) id parentParserDelegate;

@property (nonatomic, strong) NSDate *eventDate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *about;

@end
