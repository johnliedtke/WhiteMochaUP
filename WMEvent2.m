//
//  WMEvent2.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/5/14.
//
//

#import "WMEvent2.h"
#import <Parse/PFObject+Subclass.h>

@interface WMEvent2 ()

@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *details;
@property (nonatomic, strong, readwrite) NSString *type;
@property (nonatomic, strong, readwrite) NSString *location;
@property (nonatomic, strong, readwrite) NSString *category;
@property (nonatomic, strong, readwrite) NSString *subCategory;

@property (nonatomic, strong, readwrite) NSDate *start;
@property (nonatomic, strong, readwrite) NSDate *end;
@property (nonatomic, readwrite) BOOL allDay;



@end

@implementation WMEvent2
@dynamic title, details, start, end, allDay, type, category, subCategory, location;

+ (NSString *)parseClassName
{
    return @"WMEvent2";
}




























@end
