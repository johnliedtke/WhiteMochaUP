//
//  WMHomeViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/25/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WMRegisterViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
@class WMWebViewController;


@interface WMHomeViewController : UITableViewController<MFMailComposeViewControllerDelegate,PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate, RegisterViewDelegate, UITableViewDelegate, UITabBarControllerDelegate>
{
    PFLogInViewController *logInViewController;
    IBOutlet UIButton *yesButton;
    IBOutlet UIButton *noButton;
    IBOutlet UITableViewCell *pollCell;
    UIButton *noResultButton;
    UIButton *yesResultButton;
    UIRefreshControl *refreshControl;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *pollLabel;
    BOOL emailConfirmed;
    IBOutlet UITableViewCell *topPartCell;
    IBOutlet UIButton *aboutButton;
    IBOutlet UIButton *feedbackButton;
    IBOutlet UIButton *studyButton;
    NSNumber *voteCount;
    
    
    // Poll Buttons
    NSArray *voteButtons;
    IBOutlet UIButton *aButton;
    IBOutlet UIButton *bButton;
    IBOutlet UIButton *cButton;
    IBOutlet UIButton *dButton;
    
    // Result Buttons
    UIButton *aResultButton;
    UIButton *bResultButton;
    UIButton *cResultButton;
    UIButton *dResultButton;
    
    // Vote Labels
    IBOutlet UILabel *aLabel;
    IBOutlet UILabel *bLabel;
    IBOutlet UILabel *cLabel;
    IBOutlet UILabel *dLabel;
    
    // Percentage Labels
    UILabel *aPercentLabel;
    UILabel *bPercentLabel;
    UILabel *cPercentLabel;
    UILabel *dPercentLabel;
    
    IBOutlet UILabel *voteLabel;
}


@property (nonatomic, strong) PFObject *poll;
- (IBAction)aboutAction:(id)sender;
- (IBAction)feedbackAction:(id)sender;

// Result actions
- (IBAction)aAction:(id)sender;
- (IBAction)bAction:(id)sender;
- (IBAction)cAction:(id)sender;
- (IBAction)dAction:(id)sender;
- (IBAction)studyAction:(id)sender;






@end
