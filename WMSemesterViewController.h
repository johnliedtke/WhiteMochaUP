//
//  WMSemesterViewController.h
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/14/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//
//Last Modified 10/20/2013 by Derek Schumacher

//DELEGATES
//This is the child class of the reloadDelegate method. The reloadDelegate method is used by the WMSemeterFormViewController to inform the WMSemesterViewController that it needs to reload its data when a new semester object is inserted.

//INSTANCE VARIABLES
//numSemesters counts the number of semester objects sored on the phone, so we can make the correct number of rows/sections.

//PROPERTIES
//managedObjectContext is set in the WMAppDelegate in order to use core data.
//arrayOfSemesterObjects is used to display and delete semester objects from core data.

//INSTANCE METHODS
//-(void) displaySemesterAddForm is called when the + button on the navigation bar is pressed. It displays the WMSemesterformViewController

//CLASS METHODS

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WMSemesterAddFormViewController.h"
#import "WMListOfCoursesViewController.h"
#import "WMCourseDetailViewController.h"


@interface WMSemesterViewController : UITableViewController<reloadDelegate>{
    int numSemesters;
    bool hasF;
}

@property (strong, nonatomic) id<reloadDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *arrayOfSemesterObjects;
@property (strong, nonatomic) NSMutableArray *arrayOfGrades;
@property (strong, nonatomic) NSMutableArray *arrayOfCredits;

-(void) displaySemesterAddForm;
@end
