//
//  WMCourseAddGradeViewController.h
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/30/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grades.h"

@protocol reloadGradesDelegate <NSObject>

-(void) reloadGradesData;
@end

@interface WMCourseAddGradeViewController : UITableViewController<UITextFieldDelegate>
{
    NSString *assignmentName_;
    NSString *assignmentScore_;
    NSString *maximumPoints_;
    NSString *assignmentType_;
    
    UITextField *assignmentNameField_;
    UITextField *assignmentScoreField_;
    UITextField *maximumPointsField_;
    UITextField *assignmentTypeField_;
}
@property (strong, nonatomic) NSString *assignmentName;
@property (strong, nonatomic) NSString *assignmentScore;
@property (strong, nonatomic) NSString *maximumPoints;
@property (strong, nonatomic) NSString *assignmentType;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void) submit;
@end

