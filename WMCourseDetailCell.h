//
//  WMCourseDetailCell.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 7/29/13.
//
//

#import <Parse/Parse.h>

@interface WMCourseDetailCell : PFTableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *detailCellCourse;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *detailCellGrade;



@end
