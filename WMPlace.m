//
//  WMPlace.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/20/13.
//
//  This will store all the infomation associated with a place.
//

#import "WMPlace.h"
#import <Parse/PFObject+Subclass.h>

@implementation WMPlace
@dynamic name;

+ (NSString *)parseClassName
{
    return @"WMPlace";
}



@end
