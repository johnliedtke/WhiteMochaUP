//
//  WMCourseAddFormViewController.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 7/27/13.
//
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import <CoreData/CoreData.h>
#import "WMPrevNext.h"

@protocol addCourseDelegate <NSObject>
-(void) addCourse: (NSString *)courseName;
@end

@interface WMCourseAddFormViewController : UITableViewController<UITextFieldDelegate, WMPrevNextDelegate>{
    NSString *profName_;
    NSString *courseTitle_;
    NSString *courseNumber_;
    
    UITextField *profNameField_;
    UITextField *courseTitleField_;
    UITextField *courseNumberField_;
    
    WMPrevNext *prevNext;
}

-(UITextField*) makeTextField:(NSString*)text
                  placeholder: (NSString*)placeholder;

- (IBAction)textFieldFinished:(id)sender;

@property (nonatomic, unsafe_unretained) id <addCourseDelegate> courseDelegate;
@property (nonatomic,copy) NSString* profName;
@property (nonatomic, copy) NSString* courseTitle;
@property (nonatomic, copy) NSString* courseNumber;

//For Core Data:
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end