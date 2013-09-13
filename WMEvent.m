//
//  WMEvent.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/16/13.
//
//

#import "WMEvent.h"


@implementation WMEvent
@synthesize details, eventDate, eventType, user, location,clubCategory, title, club, sponsor, parseObject;


// RSS FEED init
- (id)initWithTitle:(NSString *)eventTitle location:(NSString *)loc eventType:(NSString *)type eventDate:(NSDate *)date image:(UIImage *)img
{
    self = [super init];
    if (self) {
        [self setTitle:eventTitle];
        [self setLocation:loc];
        [self setEventDate:date];
        [self setEventType:type];
        [self setImage:img];
    }
    return self;
}

// Club init
- (id)initWithClub:(NSString *)theClub location:(NSString *)loc eventType:(NSString *)type eventDate:(NSDate *)date details:(NSString *)info clubCategory:(NSString *)clubCat user:(PFUser *)lister image:(UIImage *)img
{
    self = [super init];
    if (self) {
        [self setClub: theClub];
        [self setLocation:loc];
        [self setEventDate:date];
        [self setEventType:type];
        [self setDetails:info];
        [self setClubCategory:clubCat];
        [self setUser:lister];
        [self setImage:img];
    }
    return self;
}

@end
