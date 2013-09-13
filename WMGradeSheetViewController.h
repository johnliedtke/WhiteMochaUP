//
//  WMGradeSheetViewController.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 8/3/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WMCourseGradeFormViewController.h"
#import "Grade.h"
#import "WMCourseGradeSheetCell.h"

@interface WMGradeSheetViewController : UITableViewController {
    int numberGrades;
    int index;
    NSMutableArray *gradeNameArray;
}
//For Core Data:
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *courseTitle;
@end
