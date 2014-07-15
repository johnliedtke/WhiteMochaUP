//
//  WMEvent2.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/5/14.
//
//

#import <Parse/Parse.h>

#define ALL_CATEGORY @"ALL"
#define SCHOOL_CATEGORY @"SCHOOL"
#define SPORTS_CATEGORY @"SPORTS"
#define CLUBS_CATEGORY @"CLUBS"
#define REFRESH @"REFRESH"


@interface WMEvent2 : PFObject<PFSubclassing>

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *details;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSString *location;
@property (nonatomic, strong, readonly) NSString *category;
@property (nonatomic, strong, readonly) NSString *subCategory;

@property (nonatomic, strong, readonly) NSDate *start;
@property (nonatomic, strong, readonly) NSDate *end;
@property (nonatomic, readonly) BOOL allDay;


- (BOOL)isSchoolCategory:(NSString *)event;
- (BOOL)isSportsCategory:(NSString *)event;
- (BOOL)isClubsCategory:(NSString *)event;




@end
