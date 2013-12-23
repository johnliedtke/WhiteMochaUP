//
//  WMPlaceItem.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/21/13.
//
//

#import "WMPlaceItem.h"
#import <Parse/PFObject+Subclass.h>

@interface WMPlaceItem ()
@property (nonatomic, readwrite) NSString *itemTitle;
@end

@implementation WMPlaceItem
@dynamic itemTitle;
@dynamic itemContents;



// Designated Initializer
- (id)initWithTitle:(NSString *)title contents:(NSString *)content
{
    if (self = [super init]) {
        [self setItemTitle:[title copy]];
        [self setItemContents:[content copy]];
    }
    return self;
}

+ (NSString *)parseClassName
{
    return @"WMPlaceItem";
}

@end
