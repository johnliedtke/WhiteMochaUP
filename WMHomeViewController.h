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
}


- (IBAction)yesAction:(id)sender;
- (IBAction)noAction:(id)sender;
@property (nonatomic, strong) PFObject *poll;
- (IBAction)aboutAction:(id)sender;
- (IBAction)feedbackAction:(id)sender;



@end
