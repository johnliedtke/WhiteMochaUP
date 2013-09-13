//
//  WMRegisterViewController.h
//  ParseStarterProject
//
//  Created by John Liedtke on 7/4/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WMGenderSelectViewController.h"
#import "WMYearSelectViewController.h"
#import "WMPrevNext.h"

@protocol RegisterViewDelegate <NSObject>

- (void)setUserName:(NSString *)userName;

@end

@interface WMRegisterViewController : UITableViewController <UITextFieldDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate, GenderSelectDelegate, YearSelectDelegate, WMPrevNextDelegate>
{
    UITextField *fullNameField;
    UITextField *emailField;
    UITextField *passwordField;
    UITextField *genderField;
    UITextField *schoolYearField;
    UITextField *majorField;
    UIButton *submitButton;
    WMPrevNext *prevNext;
}

@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSNumber *schoolYear;
@property (nonatomic, strong) NSString *major;
@property (nonatomic, unsafe_unretained) id <RegisterViewDelegate> registerDelegate;

@end
