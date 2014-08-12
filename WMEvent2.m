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
@property (nonatomic, strong, readwrite) NSString *sponsor;
@property (nonatomic, strong, readwrite) WMPointer *commentPointer;

@property (nonatomic, strong, readwrite) NSDate *start;
@property (nonatomic, strong, readwrite) NSDate *end;
@property (nonatomic, readwrite) BOOL allDay;



@end

@implementation WMEvent2
@dynamic title, details, start, end, allDay, type, category, subCategory, location, sponsor, commentPointer;

+ (NSString *)parseClassName
{
    return @"WMEvent2";
}

- (NSString *)displayDate
{
    if (self.allDay) {
        return @"All Day Event";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eeee, MMMM d"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *date = [dateFormatter stringFromDate:self.start];
    [dateFormatter setDateFormat:@"h:mm a"];
    NSString *startTime = [dateFormatter stringFromDate:self.start];
    if (!self.end) {
        return [NSString stringWithFormat:@"%@ %@",date,startTime];
    } else {
        NSString *endTime = [dateFormatter stringFromDate:self.end];
        return [NSString stringWithFormat:@"%@\n%@ - %@",date,startTime,endTime];
    }
}

- (BOOL)hasSubCategory
{
    return ![self.subCategory isEqualToString:@""];
}


@end
