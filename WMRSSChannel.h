//
//  WMRSSChannel.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/28/13.
//
//

#import <Foundation/Foundation.h>

@interface WMRSSChannel : NSObject <NSXMLParserDelegate>
{
    NSMutableString *currentString;
}

@property (nonatomic, unsafe_unretained) id parentParserDelegate;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *infoString;
@property (nonatomic, readonly, strong) NSMutableArray *items;


@end
