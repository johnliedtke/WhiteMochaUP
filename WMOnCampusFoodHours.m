//
//  WMHours.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 1/8/14.
//
//

#import "WMOnCampusFoodHours.h"
#import <Parse/PFObject+Subclass.h>


@implementation WMOnCampusFoodHours

@dynamic monday,tuesday,wednesday,thursday,friday,saturday,sunday,place;

+ (NSString *)parseClassName
{
    return @"WMHours";
}

- (id)initWithHours:(NSString *)mon tuesday:(NSString *)tues wednesday:(NSString *)weds thursday:(NSString *)thurs friday:(NSString *)fri saturday:(NSString *)sat sunday:(NSString *)sun place:(NSString *)plc
{
    if (self = [super init]) {
        [self setPlace:plc];
        [self setMonday:mon];
        [self setTuesday:tues];
        [self setWednesday:weds];
        [self setThursday:thurs];
        [self setFriday:fri];
        [self setSaturday:sat];
        [self setSunday:sun];
    }
    return self;
}

- (NSString *)hoursToday
{
    // Get today's day (e.g. Monday) and return corresponding hours
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *stringDate = [dateFormatter stringFromDate:[NSDate date]];
    
    if ([stringDate isEqualToString:@"Monday"])
        return [self monday];
    else if ([stringDate isEqualToString:@"Tuesday"])
        return [self tuesday];
    else if ([stringDate isEqualToString:@"Wednesday"])
        return [self wednesday];
    else if ([stringDate isEqualToString:@"Thursday"])
        return [self thursday];
    else if ([stringDate isEqualToString:@"Friday"])
        return [self friday];
    else if ([stringDate isEqualToString:@"Saturday"])
        return [self saturday];
    else
        return [self sunday];
}




@end
