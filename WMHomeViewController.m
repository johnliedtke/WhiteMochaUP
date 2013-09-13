//
//  WMHomeViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/25/13.
//
//

#import "WMHomeViewController.h"
#import "WMRegisterViewController.h"
#import "WMCustomLoginViewController.h"
#import "WMConstants.h"
#import "WMAboutSectionViewController.h"

@interface WMHomeViewController ()

@end

@implementation WMHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    PURPLEBACK
    
    // DateLabel
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d"];
    [dateLabel setText:[dateFormatter stringFromDate:[NSDate date]]];
    
    
    // Buttons
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    // orange
    UIImage *orangeButtonImage = [[UIImage imageNamed:@"orangeButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *orangeButtonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    // Grey Button
    UIImage *greyImage = [[UIImage imageNamed:@"greyButton.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *greyHighlight = [[UIImage imageNamed:@"greyButtonHighlight.png"]
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [aboutButton setBackgroundImage:greyImage forState:UIControlStateNormal];
    [aboutButton setBackgroundImage:greyHighlight forState:UIControlStateHighlighted];
    [feedbackButton setBackgroundImage:greyImage forState:UIControlStateNormal];
    [feedbackButton setBackgroundImage:greyHighlight forState:UIControlStateHighlighted];
    
    // Set the background for any states you plan to use
    [yesButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [yesButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [noButton setBackgroundImage:orangeButtonImage forState:UIControlStateNormal];
    [noButton setBackgroundImage:orangeButtonImageHighlight forState:UIControlStateHighlighted];
    
    // Title
    self.navigationItem.title = @"White Mocha";
    UIColor *color = [[UIColor alloc] initWithRed:253/255.0 green:253/255.0 blue:253/255.0 alpha:1.0];
    [[pollCell contentView] setBackgroundColor:color];
    
    [yesButton setEnabled:NO];
    [noButton setEnabled:NO];
    [self setupRefreshControl];
    [self retrieveResults];
    
    // Tab bar
    [self.tabBarController setDelegate:self];
    
    
    
    // Colors
    UIView *myView = [[UIView alloc] init];
    UIColor *whiteKind = [[UIColor alloc] initWithRed:247.0/255.0 green:247.0/255 blue:247.0/255 alpha:1.0];
    myView.backgroundColor = whiteKind;
    [topPartCell addSubview:myView];
    [topPartCell setBackgroundView:myView];
    emailConfirmed = FALSE;
    


    
}

-(void)checkEmailConfirmed
{
    if (!emailConfirmed) {
        NSLog(@"called");
    if (![PFUser currentUser]) return;
        NSString *userID = [[PFUser currentUser] objectId];
        [[PFUser query] getObjectInBackgroundWithId:userID block:^(PFObject *object, NSError *error) {
            bool confirmed = [[object objectForKey:@"emailVerified"] boolValue];
            
            if (!confirmed) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Please Confirm Email" message:@"Please confirm your email address" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [av show];
                [PFUser logOut];
                [self loginStuff];
            } else if(confirmed) {
                emailConfirmed = TRUE;
            }
        }];
    }
}

-(void)setupRefreshControl
{
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(retrieveResults) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
}

- (void)retrieveResults
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMPoll"];
    [query whereKey:@"currentPoll" equalTo:[NSNumber numberWithBool:TRUE]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            [self setPoll:object];
            [self refreshResults];
            [self hasUserVoted];
            // [self refreshResults];
        } else {
            NSLog(@"error");
        }
    }];
}

-(void)refreshResults
{
    [yesResultButton removeFromSuperview];
    [noResultButton removeFromSuperview];
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *orangeButtonImage = [[UIImage imageNamed:@"orangeButton.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
   
    // Votes
    NSNumber *yesVotes = [[self poll] objectForKey:@"yesVotes"];
    NSLog(@"%d***", [yesVotes integerValue]);
    NSNumber *noVotes = [[self poll] objectForKey:@"noVotes"];
    double totalVotes = [yesVotes doubleValue] + [noVotes doubleValue];
    
    
    // Yes Results
    yesResultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    float roundedNo = [yesVotes doubleValue] / totalVotes * 100;
    [yesResultButton setTitle:[NSString stringWithFormat:@"%.0f%% YES", roundf(roundedNo)]forState:UIControlStateNormal];
    float yesWidth = ([yesVotes doubleValue] / totalVotes) * 300;
    NSLog(@"%f width", yesWidth);
    yesResultButton.frame = CGRectMake(20, 35, yesWidth, 31.0);
    [yesResultButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [yesResultButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [[yesResultButton titleLabel] setFont:[UIFont boldSystemFontOfSize:13]];
    [pollCell addSubview:yesResultButton];
    
    // No Results
    noResultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    float rounded = [noVotes doubleValue] / totalVotes * 100;
    [noResultButton setTitle:[NSString stringWithFormat:@"%.0f%% NO", roundf(rounded)] forState:UIControlStateNormal];
    float noWidth = ([noVotes integerValue] / totalVotes) * 300;
    noResultButton.frame = CGRectMake(20, 72, noWidth, 31);
    [noResultButton setBackgroundImage:orangeButtonImage forState:UIControlStateNormal];
    [noResultButton setBackgroundImage:orangeButtonImage forState:UIControlStateHighlighted];
    [[noResultButton titleLabel] setFont:[UIFont boldSystemFontOfSize:13]];
    [pollCell addSubview:noResultButton];
    
    [pollLabel setText:[[self poll] objectForKey:@"poll"]];
    [refreshControl endRefreshing];
    //[self hasUserVoted];
}


- (void)loginStuff
{
    if (![PFUser currentUser]) { // No user logged in
        
        // Create the log in view controller
        // Create a little navigation
        
        WMCustomLoginViewController *customLogin = [[WMCustomLoginViewController alloc] init];
        [customLogin setDelegate:self];
        logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        WMRegisterViewController *registerViewController = [[WMRegisterViewController alloc] init];
        [registerViewController setRegisterDelegate:self];
        
        // Create a little navigation for the registration
        UINavigationController *loginNavigation = [[UINavigationController alloc] initWithRootViewController:registerViewController];
            UIImage *navBarImg = [UIImage imageNamed:@"navigationbar.png"];
        
        [[loginNavigation navigationBar] setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        [[loginNavigation navigationBar] setBackgroundColor:[UIColor blackColor]];
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:loginNavigation];
        [customLogin setSignUpController:loginNavigation];
        
        // Present the log in view controller
        [self presentViewController:customLogin animated:YES completion:NULL];
        
    } else if ([PFUser currentUser]) {
        //   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:[NSString stringWithFormat:@"%@ username", [[PFUser currentUser] username]] delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:nil, nil];
        // [alert show];
        [self checkEmailConfirmed];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
    [self hasUserVoted];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [self loginStuff];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d"];
    [dateLabel setText:[dateFormatter stringFromDate:[NSDate date]]];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

-(void)setUserName:(NSString *)userName
{
    [[[logInViewController logInView] usernameField] setText:userName];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Thank you for signing up! Please check your email to confirm." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
//    [alert show];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"logged in!");
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ()
/*
 - (IBAction)logOutButtonTapAction:(id)sender {
 [PFUser logOut];
 [self.navigationController popViewControllerAnimated:YES];
 }
 */




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)userVoted
{
    PFObject *updatePoll = [self poll];
    if (![[self poll] objectForKey:@"usersVoted"]) {
        NSMutableArray *usersVoted = [[NSMutableArray alloc] initWithObjects:[PFUser currentUser], nil];
        [updatePoll setObject:usersVoted forKey:@"usersVoted"];
        [updatePoll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self retrieveResults];
            } else {
                NSLog(@"ERROR");
            }
        }];
    } else {
        [updatePoll addUniqueObject:[PFUser currentUser] forKey:@"usersVoted"];
        [updatePoll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self retrieveResults];
            } else {
                NSLog(@"ERROR");
            }
        }];
    }
    [yesButton setEnabled:NO];
    [noButton setEnabled:NO];
}

- (IBAction)yesAction:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMPoll"];
    [query whereKey:@"currentPoll" equalTo:[NSNumber numberWithBool:TRUE]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *updatePoll = objects[0];
            [updatePoll incrementKey:@"yesVotes"];
            [updatePoll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //[self retrieveResults];
                    [self userVoted];
                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"There was an error!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                    [av show];
                }
            }];
        } else {

        }
    }];
}

- (IBAction)noAction:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMPoll"];
    [query whereKey:@"currentPoll" equalTo:[NSNumber numberWithBool:TRUE]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *updatePoll = objects[0];
            [updatePoll incrementKey:@"noVotes"];
            [updatePoll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //[self retrieveResults];
                    [self userVoted];
                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"There was an error!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                    [av show];
                }
            }];
        } else {
            
        }
    }];
}

-(void)hasUserVoted
{
    NSArray *usersVoted = [[self poll] objectForKey:@"usersVoted"];
    NSString *currentUserID = [[PFUser currentUser] objectId];
    BOOL voted = NO;
    for (PFUser *user in usersVoted) {
        // Get ID
        NSString *objectID = [user objectId];
        if ([currentUserID isEqualToString:objectID]) {
            NSLog(@"YES USER IS IN THERE");
            voted = YES;
        }

    }
    if (voted) {
            [yesButton setEnabled:NO];
            [noButton setEnabled:NO];
    } else {
        [yesButton setEnabled:YES];
        [noButton setEnabled:YES];
    }
}
- (IBAction)aboutAction:(id)sender
{
    UIStoryboard *about = [UIStoryboard storyboardWithName:@"WMAboutSection" bundle:nil];
    WMAboutSectionViewController *aboutViewController = [about instantiateViewControllerWithIdentifier:@"WMAboutSection"];
    [[self navigationController] pushViewController:aboutViewController animated:YES];
}

- (IBAction)feedbackAction:(id)sender
{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    [mailController setMailComposeDelegate:self];
    [mailController setSubject:@"White Mocha FEEDBACK"];
    [mailController setToRecipients:[[NSArray alloc] initWithObjects:@"liedtke15@up.edu",@"schumach15@up.edu", nil]];
    [self presentViewController:mailController animated:YES completion:NULL];    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
