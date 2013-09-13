//
//  WMCourseGradeFormViewController.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 7/31/13.
//
//

#import <UIKit/UIKit.h>
#import "WMCourseGradeEntryViewController.h"
#import "WMGradeSheetViewController.h"
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>
#import "Grade.h"

//Delegate method to pass the course name to the Grade entry form:
@protocol sendCourseTitleDelegate <NSObject>
-(void) sendCourseTitle: (NSString *) courseTitle;
@end

@interface WMCourseGradeFormViewController : UITableViewController<UITextFieldDelegate, sendCourseTitleDelegate>{
    NSString *score_;
    NSString *assignmentName_;
    NSString *maxPoints_;
    
    UITextField *scoreField_;
    UITextField *assignmentNameField_;
    UITextField *maxPointsField_;
    
    int numGrades;
}

-(UITextField*) makeTextField:(NSString*)text
                  placeholder: (NSString*)placeholder;

- (IBAction)textFieldFinished:(id)sender;

@property (nonatomic,copy) NSString* score;
@property (nonatomic, copy) NSString *assignmentName;
@property (nonatomic, strong) NSString *gradeType;
@property (nonatomic, strong) NSString *courseTitle;
@property (nonatomic, strong) NSString *maxPoints;

//For core data:
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@end
