//
//  WMOnCampusFood.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 1/5/14.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@class WMOnCampusFoodHours;

@interface WMOnCampusFood : PFObject<PFSubclassing>


// Display Information
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *displayDescription;
@property (nonatomic, copy) PFFile *displayImage;

@property (nonatomic, strong) WMOnCampusFoodHours *hours;

+ (NSString *)parseClassName;

@end
