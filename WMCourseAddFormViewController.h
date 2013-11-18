//
//  WMCourseAddFormViewController.h
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/23/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WMCourseObject.h"

@protocol reloadCoursesDelegate <NSObject>

-(void) reloadCourseData;
@end

@interface WMCourseAddFormViewController : UITableViewController<UITextFieldDelegate>
{
    NSString *courseTitle_;
    NSString *profName_;
    NSString *numCredits_;
    
    UITextField * courseTitleField_;
    UITextField *profNameField_;
    UITextField *numCreditsField_;
}

@property (nonatomic,copy) NSString *courseTitle;
@property (nonatomic, copy) NSString *profName;
@property (nonatomic, copy) NSString *numCredits;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void) formSubmit;
-(UITextField*) makeTextField:(NSString*)text
                  placeholder: (NSString*)placeholder;

- (IBAction)textFieldFinished:(id)sender;

@end
