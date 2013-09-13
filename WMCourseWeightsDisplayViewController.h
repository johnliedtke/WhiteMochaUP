//
//  WMCourseWeightsDisplayViewController.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 8/12/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Course.h"

@interface WMCourseWeightsDisplayViewController : UITableViewController

@property (strong, nonatomic) NSString * courseName;
//For Core Data:
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;



@end
