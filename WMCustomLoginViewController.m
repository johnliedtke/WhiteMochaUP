//
//  WMCustomLoginViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/22/13.
//
//

#import "WMCustomLoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WMCustomLoginViewController ()

@end

@implementation WMCustomLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // exit
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"exit1.png"] forState:UIControlStateNormal];
    //[self.logInView.dismissButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateHighlighted];

    
    // Logo
	[self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBack.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginLogo.png"]]];
    
    
    // Sign up
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signupHover.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Log in button
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"loginButtonNew.png"] forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"loginButtonNewHover.png"] forState:UIControlStateHighlighted];
    
    
    [[[self logInView] signUpLabel] setText:@"Only @up.edu emails!"];
    [[[self logInView] signUpLabel] setTextColor:[UIColor whiteColor]];
    
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    [[[self logInView] passwordForgottenButton] setBackgroundImage:nil forState:UIControlStateNormal];
    
    
    // Add login field background
    fieldsBackgroud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBox.png"]];
    [self.logInView addSubview:fieldsBackgroud];
    [self.logInView sendSubviewToBack:fieldsBackgroud];
    
    [self.logInView.usernameField setTextColor:[UIColor blackColor]];
    [self.logInView.passwordField setTextColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.logInView.logo setFrame:CGRectMake(83.0f, 30.0f, 148.0f, 80.0f)];
    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 315.0f, 250.0f, 41.0f)];
    [self.logInView.logInButton setFrame:CGRectMake(35.0f, 225.0f, 250.0f, 41.0f)];
    [self.logInView.logInButton setTitle:@" " forState:UIControlStateNormal];
    [self.logInView.logInButton setTitle:@" " forState:UIControlStateHighlighted];
   // UIColor *color = [UIColor whiteColor];
   // self.logInView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
   // self.logInView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    [fieldsBackgroud setFrame:CGRectMake(35.0f,130.0f, 251.0f, 80.0f)];
    
    [self.logInView.usernameField setFrame:CGRectMake(95.0f, 125.0f, 190.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(95.0f, 165.0f, 190.0f, 50.0f)];
    [self.logInView.usernameField setTextAlignment:NSTextAlignmentLeft];
    [self.logInView.passwordField setTextAlignment:NSTextAlignmentLeft];
 
}


@end
