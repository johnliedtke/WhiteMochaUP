//
//  WMUser.h
//  ParseStarterProject
//
//  Created by John Liedtke on 7/3/13.
//
//
#import <Parse/Parse.h>

@interface WMUser : PFUser<PFSubclassing>
{
    NSString *username;
}



@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *onOffCampus;














@end



