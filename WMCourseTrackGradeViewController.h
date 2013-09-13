//
//  WMCourseTrackGradeViewController.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 7/28/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>
#import "WMCourseDetailController.h"
#import "WMCourseGradeEntryViewController.h"
#import "Course.h"
#import "WMPrevNext.h"
/*
 @protocol weightDataDelegate <NSObject>
 -(void) sendCourseName: (NSString *) courseName;
 @end
 */
@interface WMCourseTrackGradeViewController : UITableViewController<UITextFieldDelegate,WMPrevNextDelegate/*, weightDataDelegate*/>{
    NSString *homeWorkWeight_;
    NSString *testWeight_;
    NSString *essayWeight_;
    NSString *quizWeight_;
    NSString *attendanceWeight_;
    NSString *finalExamWeight_;
    NSString *otherWeight_;
    
    
    
    UITextField *homeWorkWeightField_;
    UITextField *testWeightField_;
    UITextField *essayWeightField_;
    UITextField *quizWeightField_;
    UITextField *attendanceWeightField_;
    UITextField *finalExamWeightField_;
    UITextField *otherWeightField_;
    
    WMPrevNext *prevNext;
    
}

-(UITextField*) makeTextField:(NSString*)text
                  placeholder: (NSString*)placeholder;
- (IBAction)textFieldFinished:(id)sender;
@property (nonatomic,strong) NSString *homeWorkWeight;
@property (nonatomic,strong) NSString *testWeight;
@property (nonatomic, strong) NSString *essayWeight;
@property (nonatomic, copy) NSString *quizWeight;
@property (nonatomic, strong) NSString *attendanceWeight;
@property (nonatomic, strong) NSString *finalExamWeight;
@property (nonatomic, strong) NSString *otherWeight;

@property (nonatomic, strong) NSString *courseTitle;

//For Core Data:
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;



//@property (nonatomic, unsafe_unretained) id <weightDataDelegate> weightDelegate;
@end

