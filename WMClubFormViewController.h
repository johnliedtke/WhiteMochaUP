//
//  WMClubFormViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/15/13.
//
//

#import <UIKit/UIKit.h>
#import "WMPrevNext.h"
#import <Parse/Parse.h>
#import "WMAddEventDelegate.h"

@interface WMClubFormViewController : UITableViewController <WMPrevNextDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    __weak IBOutlet UITextField *clubField;
    __weak IBOutlet UITextField *dateField;
    __weak IBOutlet UITextField *locationField;
    __weak IBOutlet UITextView *detailsTextView;
    __weak IBOutlet UITextField *typeField;
    IBOutlet UILabel *postLabel;
    
    // Pickers
    UIDatePicker *datePicker;
    UIPickerView *clubPicker;
    UIPickerView *clubTypePicker;
    
    // Club Data
    NSDictionary *clubs;
    NSArray *clubType;
    
    // Other
    WMPrevNext *prevNext;
  
}

    // Delegate
@property (nonatomic, weak) id <WMAddEventDelegate> addEventDelegate;

@end
