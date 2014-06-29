//
//  WMPollViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/1/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WMRegisterViewController.h"


@interface WMPollViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate,RegisterViewDelegate,UIAlertViewDelegate>
{
    PFLogInViewController *logInViewController;
}

@end
