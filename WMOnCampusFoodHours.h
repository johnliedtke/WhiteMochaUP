//
//  WMHours.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 1/8/14.
//
//

#import <Parse/Parse.h>

@interface WMOnCampusFoodHours : PFObject<PFSubclassing>

@property (nonatomic, copy) NSString *place;

@property (nonatomic, copy) NSString *monday;
@property (nonatomic, copy) NSString *tuesday;
@property (nonatomic, copy) NSString *wednesday;
@property (nonatomic, copy) NSString *thursday;
@property (nonatomic, copy) NSString *friday;
@property (nonatomic, copy) NSString *saturday;
@property (nonatomic, copy) NSString *sunday;


// Dedicated Init
- (id)initWithHours:(NSString *)mon tuesday:(NSString *)tues wednesday:(NSString *)weds thursday:(NSString *)thurs friday:(NSString *)fri saturday:(NSString *)sat sunday:(NSString *)sun place:(NSString *)plc;


// Returns the hours for current day
- (NSString *)hoursToday;

+ (NSString *)parseClassName;

@end
