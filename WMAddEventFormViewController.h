//
//  WMAddEventFormViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/19/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WMPrevNext.h"
#import "WMAddEventDelegate.h"

@interface WMAddEventFormViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate, WMPrevNextDelegate>
{
    __weak IBOutlet UILabel *eventLabel;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UILabel *sponsorLabel;
    
    __weak IBOutlet UITextField *eventField;
    __weak IBOutlet UITextField *dateField;
    __weak IBOutlet UITextField *locationField;
    __weak IBOutlet UITextField *sponsorField;
    __weak IBOutlet UITextView *detailsTextView;

    // Date
    UIDatePicker *datePicker;
    
    // Prev next
    WMPrevNext *prevNext;
    
    // Labels
    IBOutlet UILabel *postEventLabel;
}

@property (nonatomic, strong) NSString *eventType;


// Delegate
@property (nonatomic, weak) id <WMAddEventDelegate> addEventDelegate;

@end
