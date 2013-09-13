//
//  WMUser.m
//  ParseStarterProject
//
//  Created by John Liedtke on 7/3/13.
//
//

#import "WMUser.h"

@implementation WMUser

@dynamic firstName, lastName, gender, onOffCampus, year;






- (void)setUsername:(NSString *)u
{
    username = [NSString stringWithFormat:@"%@ %@", [self firstName], [self lastName]];
}

- (NSString *)username
{
    return username;
}


@end
