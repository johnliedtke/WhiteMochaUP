//
//  RootTableViewController.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 8/13/13.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WMCourseAddFormViewController.h"
#import <CoreData/CoreData.h>
#import "WMCourseCell.h"
#import "WMCourseDetailController.h"
#import "WMCourseAddFormViewController.h"

@interface RootTableViewController : UITableViewController <addCourseDelegate>{
    NSMutableArray *courseNameArray;
    //int index;
    //int counter;
    int previousCounter;
}

//For Core Data:
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, strong) NSMutableArray *professorNameArray;
@end

