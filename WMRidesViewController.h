//
//  WMRidesViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/8/13.
//
//

#import <UIKit/UIKit.h>
#import "WMPrevNext.h"
#import <Parse/Parse.h>

@interface WMRidesViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, WMPrevNextDelegate>
{
    WMPrevNext *prevNext;
    UIDatePicker *datePicker;
    __weak IBOutlet UITextField *toField;
    __weak IBOutlet UITextField *fromField;
    __weak IBOutlet UITextField *whenField;
    __weak IBOutlet UITextField *feeField;
    __weak IBOutlet UITextView *otherInfoTextView;
    
}

@end
