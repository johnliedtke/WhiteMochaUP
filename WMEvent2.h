//
//  WMEvent2.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/5/14.
//
//

#import <Parse/Parse.h>
#import "WMPointer.h"

#define ALL_CATEGORY @"ALL"
#define SCHOOL_CATEGORY @"SCHOOL"
#define SPORTS_CATEGORY @"SPORTS"
#define CLUBS_CATEGORY @"CLUBS"
#define FUN_CATEGORY @"FUN"
#define REFRESH @"REFRESH"


@interface WMEvent2 : PFObject<PFSubclassing>

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *details;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSString *location;
@property (nonatomic, strong, readonly) NSString *category;
@property (nonatomic, strong, readonly) NSString *subCategory;
@property (nonatomic, strong, readonly) NSString *sponsor;

@property (nonatomic, strong, readonly) NSDate *start;
@property (nonatomic, strong, readonly) NSDate *end;
@property (nonatomic, readonly) BOOL allDay;
@property (nonatomic, readonly) WMPointer *commentPointer;



- (NSString *)displayDate;
- (BOOL)hasSubCategory;




@end
