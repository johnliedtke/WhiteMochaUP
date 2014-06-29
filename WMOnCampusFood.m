//
//  WMOnCampusFood.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 1/5/14.
//
//

#import "WMOnCampusFood.h"
#import <Parse/PFObject+Subclass.h>

@interface WMOnCampusFood ()
//@property (nonatomic, readwrite) NSString *displayName;
@end


@implementation WMOnCampusFood
@dynamic displayName,displayDescription,displayImage, hours;


+ (NSString *)parseClassName
{
    return @"WMOnCampusFood";
}

@end
