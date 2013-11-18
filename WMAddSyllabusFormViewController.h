//
//  WMAddSyllabusFormViewController.h
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/30/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WMCourseObject.h"
#import "WMCourseAddGradeViewController.h"

@interface WMAddSyllabusFormViewController : UITableViewController<UITextFieldDelegate>
{
    NSString *quizWeight_;
    NSString *testWeight_;
    NSString *essayWeight_;
    NSString *hwWeight_;
    NSString *attendanceWeight_;
    NSString *finalExamWeight_;
    NSString *otherWeight_;
    
    UITextField *quizWeightField_;
    UITextField *testWeightField_;
    UITextField *essayWeightField_;
    UITextField *hwWeightField_;
    UITextField *attendanceWeightField_;
    UITextField *finalExamWeightField_;
    UITextField *otherWeightField_;
    
}

@property (nonatomic, copy) NSString *quizWeight;
@property (nonatomic, copy) NSString *testWeight;
@property (nonatomic, copy) NSString *essayWeight;
@property (nonatomic, copy) NSString *hwWeight;
@property (nonatomic, copy) NSString *attendanceWeight;
@property (nonatomic, copy) NSString *finalExamWeight;
@property (nonatomic, copy) NSString *otherWeight;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(UITextField*) makeTextField:(NSString*)text
                  placeholder: (NSString*)placeholder;

- (IBAction)textFieldFinished:(id)sender;
-(void) formSubmit;
@end
