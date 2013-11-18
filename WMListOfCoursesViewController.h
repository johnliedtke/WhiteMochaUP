//
//  WMListOfCoursesViewController.h
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/21/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "Course.h"
#import "WMCourseAddFormViewController.h"
#import "WMCourseDetailViewController.h"

@interface WMListOfCoursesViewController : UITableViewController<reloadCoursesDelegate>
{
    int numCourses;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *arrayOfCourseObjects;
@property (strong, nonatomic) NSString *semesterTitle;
@end
