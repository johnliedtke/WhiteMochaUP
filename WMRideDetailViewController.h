//
//  WMRideDetailViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/11/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WMPrevNext.h"
#import "WMGeneralDescriptionViewController.h"


@protocol WMRideDetailDelegate <NSObject>

@optional
- (void)deleteRide:(PFObject *)ride;

@end

@interface WMRideDetailViewController : UITableViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,UITextFieldDelegate, UITableViewDelegate, WMPrevNextDelegate, WMGeneralDescriptionDelegate>
{
    __weak IBOutlet UILabel *rideDetailsLabel;
    __weak IBOutlet UITextField *toField;
    __weak IBOutlet UITextField *fromField;
    __weak IBOutlet UITextField *departureField;
    __weak IBOutlet UITextField *feeField;
    __weak IBOutlet UITextField *driverField;
    NSArray *editFields;
    __weak IBOutlet UILabel *emaiLabel;
    
    __weak IBOutlet UITableViewCell *emailCell;
    UIBarButtonItem *editButton;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *deleteButton;
    WMPrevNext *prevNext;
    UIDatePicker *datePicker;
    
    // For editing
    NSString *to;
    NSString *from;
    NSDate *departure;
    NSString *fee;
    IBOutlet UILabel *textLabel;
}

@property (nonatomic, strong) PFObject *ride;
@property (nonatomic, strong) PFObject *driver;
@property (nonatomic, weak) id <WMRideDetailDelegate> delegate;


@end
