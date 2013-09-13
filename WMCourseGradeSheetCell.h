//
//  WMCourseGradeSheetCell.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 8/10/13.
//
//

#import <UIKit/UIKit.h>

@interface WMCourseGradeSheetCell : UITableViewCell{
    
}
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *gradeType;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *scoreFraction;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *scorePercent;
//@property (unsafe_unretained, nonatomic) IBOutlet UILabel *courseTitle;


@end