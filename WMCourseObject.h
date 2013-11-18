//
//  WMCourseObject.h
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/15/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

//Last modified 10/15/13 by Derek Schumacher

//This is the header file for a WMCourseObject. This is an object that contains all the properties needed for a course object. It conveniently handles its own core data management, meaning it has the capability to pull and save its own information out of core data.


//INSTANCE VARIABLES:

//PROPERTIES:
//courseTitle will store the course name and number
//profName will store the name of the professor of the coures
//semesterTitle will store which semester a particular instance belongs to
//gradeValues will store the the grading scale.
//courseWeights will store the weights of each grading category
//gradeObjects will store all of the grade values from that course in it
//managedObjectContext will store the managedObjectContext so we don't need to ask for it twice


// INSTANCE METHODS:
//-(int) loadData Initializes the object by loading the data from the core data.
    //returns SUCCESS if the load was successful. returns FAILURE it is is not.
//-(int) saveData: Saves the data stored by an instance of WMCourseObject to core data.
    //saveData returns SUCCESS if the save was successful, and a FAILURE if it was not.

// CLASS METHODS:

#import <Foundation/Foundation.h>
#import "Course.h"


#define SUCCESS 1
#define FAILURE 0


@interface WMCourseObject : NSObject
@property (nonatomic, strong) NSString *courseTitle;
@property (nonatomic, strong) NSString *profName;
@property (nonatomic, strong) NSString *semesterTitle;
@property (nonatomic, strong) NSString *numCredits;

@property (nonatomic, strong) NSMutableArray *gradeValues;
@property (nonatomic, strong) NSMutableArray *courseWeights;
@property (nonatomic, strong) NSMutableArray *gradeObjects;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;




-(int) loadData: (NSString *) title withObjectContext: (NSManagedObjectContext *) context;
-(int) saveData;
@end
