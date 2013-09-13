//
//  WMCourseCell.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 7/21/13.
//
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface WMCourseCell : PFTableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *courseLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *courseTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *profNameLabel;

@end