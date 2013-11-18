//
//  WMSemesterAddFormViewController.h
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/23/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//
// Last Modified: 10/23/2013 by Derek Schumacher
//
//This is the form where users add new semesters.

//DELEGATES
//the reloadDelegate is called when the submit button is pressed (so it is called in the formSubmit method), and sends a message to the WMSemesterViewController to reload its data.
//the UITextFieldDelegate allows for the text fields to be used.

//INSTANCE VARIABLES
//semesterTitle_ and semesterTitleField_ are used to create the text fields

//PROPERTIES
//semesterTitle is set by the text field, and is used to save that value in core data.
//managedObjectContext allows for core data to be used

//INSTANCE METHODS
//-(void) formSubmit this method is called when the submit button is pressed, and saves the data from the text field into core data.
//_(UITextField*) makeTextField:(NSString *) text placeholder: (NSString *) placeholder generates the text fields
//(IBAction) textFieldFinished: (id) sender is a workaround to hide the keyboard when the done button is pressed

//CLASS METHODS


@protocol reloadDelegate <NSObject>
-(void) reloadData;
@end

#import <UIKit/UIKit.h>
#import "WMCourseObject.h"
#import "WMSemesterViewController.h"



@interface WMSemesterAddFormViewController : UITableViewController<UITextFieldDelegate>
{
    NSString *semesterTitle_;
    
    UITextField *semesterTitleField_;
}

@property (nonatomic,copy) NSString* semesterTitle;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;



-(void) formSubmit;
-(UITextField*) makeTextField:(NSString*)text
                  placeholder: (NSString*)placeholder;

- (IBAction)textFieldFinished:(id)sender;
@end

