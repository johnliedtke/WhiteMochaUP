//
//  WMCourseDetailViewController.h
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/29/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMCourseAddGradeViewController.h"
#import "WMAddSyllabusFormViewController.h"
#import "Course.h"
#import "WMSemesterViewController.h"
#import "WMAddGradingScaleViewController.h"

@interface WMCourseDetailViewController : UITableViewController<reloadGradesDelegate>
{
    int numGrades;
    int numRows;
    NSMutableArray *gradeObjectsArray;
    NSString * currentGrade;
    Course *thisCourse;
    bool hasF;
}

@property (nonatomic, copy) NSString *aValue;
@property (nonatomic, copy) NSString *aMinusValue;
@property (nonatomic, copy) NSString *bPlusValue;
@property (nonatomic, copy) NSString *bValue;
@property (nonatomic, copy) NSString *bMinusValue;
@property (nonatomic, copy) NSString *cPlusValue;
@property (nonatomic, copy) NSString *cValue;
@property (nonatomic, copy) NSString *cMinusValue;
@property (nonatomic, copy) NSString *dPlusValue;
@property (nonatomic, copy) NSString *dValue;
@property (nonatomic, copy) NSString *dMinusValue;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void) calculateCurrentGrade; //Changes the grade instance variable to the approprate char

@end
