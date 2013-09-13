//
//  WMCourseGradeEntryViewController.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 7/29/13.
//
//

#import <UIKit/UIKit.h>
#import "WMCourseDetailController.h"


//Delegate to allow the course title to be used by WMCourseGradeViewController,
//so we can store the entered grades properly.
@protocol addGradeDelegate <NSObject>
-(void) setCourseTitle: (NSString *) courseTitle;
@end

@interface WMCourseGradeEntryViewController : UITableViewController <addGradeDelegate>
@property (nonatomic,strong) NSString *courseName;
//For Core Data:
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
