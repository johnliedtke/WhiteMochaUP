//
//  WMEvent.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/16/13.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface WMEvent : NSObject
{
    
}

@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSDate *eventDate;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;


// Club Specific 
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *clubCategory;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *club;

// Other
@property (nonatomic, strong) NSString *sponsor;
@property (nonatomic, strong) PFObject *parseObject;


// RSS Item
@property (nonatomic) BOOL isRSS;


// The club
- (id)initWithTitle:(NSString *)title location:(NSString *)loc eventType:(NSString *)type eventDate:(NSDate *)date image:(UIImage *)img;
// Club init
- (id)initWithClub:(NSString *)theClub location:(NSString *)loc eventType:(NSString *)type eventDate:(NSDate *)date details:(NSString *)info clubCategory:(NSString *)clubCat user:(PFUser *)lister image:(UIImage *)img;


@end
