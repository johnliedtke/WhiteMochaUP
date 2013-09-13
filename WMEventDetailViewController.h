//
//  WMEventDetailViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/19/13.
//
//

#import <UIKit/UIKit.h>
#import "WMEvent.h"
#import <Parse/Parse.h>

@interface WMEventDetailViewController : UITableViewController
{
    __weak IBOutlet UITextField *titleField;
    __weak IBOutlet UITextField *locationField;
    __weak IBOutlet UITextField *timeField;
    __weak IBOutlet UITextField *creatorField;
    __weak IBOutlet UITextField *sponsorField;
    __weak IBOutlet UITextView *detailsTextView;
    
    // Edit Crap
    NSArray *editFields;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *deleteButton;
    UIDatePicker *datePicker;
    
}

@property (nonatomic, strong) WMEvent *event;


// Save state
@property (nonatomic, strong) NSString *titleEvent;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *sponsor;
@property (nonatomic, strong) NSString *details;

@end
