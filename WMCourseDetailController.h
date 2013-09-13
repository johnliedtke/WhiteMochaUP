//
//  WMCourseDetailController.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 7/26/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import "WMCourseTrackGradeViewController.h"
#import "Grade.h"
#import "WMCourseDetailCell.h"
#import "WMCourseAddFormViewController.h"
#import "WMCourseTrackGradeViewController.h"
#import "WMCourseGradeEntryViewController.h"
#import "WMGradeSheetViewController.h"
#import "WMCourseWeightsDisplayViewController.h"
#import "WMCourseChangeGradingScaleViewController.h"
#import "WMCourseScaleViewController.h"



@interface WMCourseDetailController : UITableViewController <UITableViewDelegate>
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *grade;

@property (strong, nonatomic) NSString *quizWeight;
@property (strong, nonatomic) NSString *testWeight;
@property (strong, nonatomic) NSString *essayWeight;
@property (strong, nonatomic) NSString *homeworkWeight;
@property (strong, nonatomic) NSString *attendanceWeight;
@property (strong, nonatomic) NSString *finalExamWeight;
@property (strong, nonatomic) NSString *otherWeight;

//For Core Data:
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


-(NSString *) calculateGradewithQuizScores: (NSMutableArray *) quizScores essayScores: (NSMutableArray *) essayScores testScores: (NSMutableArray *) testScores homeworkScores: (NSMutableArray *) homeworkScores attendanceScores: (NSMutableArray *) attendanceScores finalExamScores: (NSMutableArray *) finalExamScores otherScores: (NSMutableArray *) otherScores maxQuizScores: (NSMutableArray *) maxQuizScores maxEssayScores: (NSMutableArray *) maxEssayScores maxTestScores: (NSMutableArray *) maxTestScores maxHomeworkScores: (NSMutableArray *) maxHomeworkScores maxAttendaceScores: (NSMutableArray *) maxAttendanceScores maxFinalExamScore: (NSMutableArray *) maxFinalExamScore maxOtherScores: (NSMutableArray *) maxOtherScores;
@end

