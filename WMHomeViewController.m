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
#import "WMWebViewController.h"
#import "WMNavigationController.h"
#import "WMAddPollQuestionViewController.h"

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
    
    
    // Blue Button
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    // Orange Button
    UIImage *orangeButtonImage = [[UIImage imageNamed:@"orangeButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *orangeButtonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    // Grey Button
    UIImage *greyImage = [[UIImage imageNamed:@"greyButton.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *greyHighlight = [[UIImage imageNamed:@"greyButtonHighlight.png"]
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    // Green Button
    UIImage *greenImage = [[UIImage imageNamed:@"greenButton.png"]
                          resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *greenHighlight = [[UIImage imageNamed:@"greenButtonHighlight.png"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    // Tan Button
    UIImage *tanImage = [[UIImage imageNamed:@"tanButton.png"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *tanHighlight = [[UIImage imageNamed:@"tanButtonHighlight.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [aboutButton setBackgroundImage:greyImage forState:UIControlStateNormal];
    [aboutButton setBackgroundImage:greyHighlight forState:UIControlStateHighlighted];
    [feedbackButton setBackgroundImage:greyImage forState:UIControlStateNormal];
    [feedbackButton setBackgroundImage:greyHighlight forState:UIControlStateHighlighted];
    [studyButton setBackgroundImage:greyImage forState:UIControlStateNormal];
    [studyButton setBackgroundImage:greyHighlight forState:UIControlStateHighlighted];
    
    // Set the background for any states you plan to use
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [aButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [bButton setBackgroundImage:orangeButtonImage forState:UIControlStateNormal];
    [bButton setBackgroundImage:orangeButtonImageHighlight forState:UIControlStateHighlighted];
    [cButton setBackgroundImage:greenImage forState:UIControlStateNormal];
    [cButton setBackgroundImage:greenHighlight forState:UIControlStateHighlighted];
    [dButton setBackgroundImage:tanImage forState:UIControlStateNormal];
    [dButton setBackgroundImage:tanHighlight forState:UIControlStateHighlighted];
    
    
    // Title
    self.navigationItem.title = @"White Mocha";
    UIColor *color = [[UIColor alloc] initWithRed:253/255.0 green:253/255.0 blue:253/255.0 alpha:1.0];
    [[pollCell contentView] setBackgroundColor:color];
    
    // Init button states
    voteButtons = [[NSArray alloc] initWithObjects:aButton, bButton, cButton, dButton, nil];
    [self enableVoteButtons:NO];
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

-(void)addNewPoll
{
    UIStoryboard *storyPoll = [UIStoryboard storyboardWithName:@"WMAddPoll" bundle:nil];
    WMAddPollQuestionViewController *addPollVC = [storyPoll instantiateViewControllerWithIdentifier:@"WMAddPoll"];
    [[self navigationController] pushViewController:addPollVC animated:YES];
    
}

// Enable/Diable Vote Buttons
- (void)enableVoteButtons:(BOOL)enable
{
    for (UIButton *b in voteButtons) {
        [b setEnabled:enable];
    }
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
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
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
    //[yesResultButton removeFromSuperview];
    //[noResultButton removeFromSuperview];
    // Remove button to refresh
    
    [aLabel setText:[[self poll] objectForKey:@"aVote"]];
    [aButton setTitle:[[self poll] objectForKey:@"aVote"] forState:UIControlStateNormal];
    [bLabel setText:[[self poll] objectForKey:@"bVote"]];
    [bButton setTitle:[[self poll] objectForKey:@"bVote"] forState:UIControlStateNormal];
    [cButton setTitle:[[self poll] objectForKey:@"cVote"] forState:UIControlStateNormal];
    [cLabel setText:[[self poll] objectForKey:@"cVote"]];
    [dLabel setText:[[self poll] objectForKey:@"dVote"]];
    [dButton setTitle:[[self poll] objectForKey:@"dVote"] forState:UIControlStateNormal];
    
    
    
    
    NSArray *resultButtons = [[NSArray alloc] initWithObjects:aResultButton, bResultButton, cResultButton, dResultButton, nil];
    for (UIButton *b in resultButtons) {
        [b removeFromSuperview];
    }
    
    
    
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *orangeButtonImage = [[UIImage imageNamed:@"orangeButton.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *greenButtonImage = [[UIImage imageNamed:@"greenButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *tanButtonImage = [[UIImage imageNamed:@"tanButton.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
   
    // Votes
    NSNumber *aVotes = [[self poll] objectForKey:@"aVotes"];
    NSNumber *bVotes = [[self poll] objectForKey:@"bVotes"];
    NSNumber *cVotes = [[self poll] objectForKey:@"cVotes"];
    NSNumber *dVotes = [[self poll] objectForKey:@"dVotes"];
    NSArray *votesArray = [[NSArray alloc] initWithObjects:aVotes,bVotes,cVotes,dVotes, nil];
    
    double totalVotes = [aVotes doubleValue] + [bVotes doubleValue] + [cVotes doubleValue] + [dVotes doubleValue];
    
    // Calculate max
    double maxVotes = [aVotes doubleValue];
    for (NSNumber *number in votesArray) {
        if (maxVotes < [number doubleValue])
            maxVotes = [number doubleValue];
    }
    
    voteCount = [NSNumber numberWithDouble:totalVotes];
    
    int multFactor = 180;
    int xSpace = 105;
    int height = 25;
    UIColor *blueColor = [[UIColor alloc] initWithRed:76.0/255.0 green:142.0/255.0 blue:215.0/255.0 alpha:1.0];
    UIColor *redColor = [[UIColor alloc] initWithRed:218.0/255.0 green:80.0/255.0 blue:36.0/255.0 alpha:1.0];
    UIColor *greenColor = [[UIColor alloc] initWithRed:153.0/255.0 green:168.0/255.0 blue:70.0/255.0 alpha:1.0];
    UIColor *orangeColor = [[UIColor alloc] initWithRed:219.0/255.0 green:160.0/255.0 blue:34.0/255.0 alpha:1.0];
    
    // A Results
    aResultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    float aRounded = [aVotes doubleValue] / totalVotes * 100;
    //[aResultButton setTitle:[NSString stringWithFormat:@"%.0f%%", roundf(aRounded)]forState:UIControlStateNormal];
    float aWidth;
    if ([aVotes doubleValue] == maxVotes) {
        aWidth = multFactor;
    } else {
         aWidth = ([aVotes doubleValue] / totalVotes) * multFactor + 10;
    }
    aPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xSpace+aWidth+5, 41, 35, 21)];
    [aPercentLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [aPercentLabel setText:[NSString stringWithFormat:@"%.0f%%", roundf(aRounded)]];
    [pollCell addSubview:aPercentLabel];
    aResultButton.frame = CGRectMake(xSpace, 40, aWidth, height);
    //[aResultButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    //[aResultButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [aResultButton setBackgroundColor:blueColor];
    [[aResultButton titleLabel] setFont:[UIFont boldSystemFontOfSize:13]];
    [pollCell addSubview:aResultButton];
    
    // B Results
    bResultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    float bRounded = [bVotes doubleValue] / totalVotes * 100;
    //[bResultButton setTitle:[NSString stringWithFormat:@"%.0f%%", roundf(bRounded)]forState:UIControlStateNormal];
    float bWidth;
    if ([bVotes doubleValue] == maxVotes) {
        bWidth = multFactor;
    } else {
        bWidth = ([bVotes doubleValue] / totalVotes) * multFactor + 10;
    }
    bPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xSpace+bWidth+5, 82, 35, 21)];
    [bPercentLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [bPercentLabel setText:[NSString stringWithFormat:@"%.0f%%", roundf(bRounded)]];
    [pollCell addSubview:bPercentLabel];
    bResultButton.frame = CGRectMake(xSpace, 82, bWidth, height);
    //[bResultButton setBackgroundImage:orangeButtonImage forState:UIControlStateNormal];
    //[bResultButton setBackgroundImage:orangeButtonImage forState:UIControlStateHighlighted];
    [bResultButton setBackgroundColor:redColor];
    [[bResultButton titleLabel] setFont:[UIFont boldSystemFontOfSize:13]];
    [pollCell addSubview:bResultButton];
    
    // C Results
    cResultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    float cRounded = [cVotes doubleValue] / totalVotes * 100;
    //[cResultButton setTitle:[NSString stringWithFormat:@"%.0f%%", roundf(cRounded)]forState:UIControlStateNormal];
    float cWidth;
    if ([cVotes doubleValue] == maxVotes) {
        cWidth = multFactor;
    } else {
        cWidth = ([cVotes doubleValue] / totalVotes) * multFactor + 10;
    }
    cPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xSpace+cWidth+5, 124, 35, 21)];
    [cPercentLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [cPercentLabel setText:[NSString stringWithFormat:@"%.0f%%", roundf(cRounded)]];
    [pollCell addSubview:cPercentLabel];
    cResultButton.frame = CGRectMake(xSpace, 125, cWidth, height);
   // [cResultButton setBackgroundImage:greenButtonImage forState:UIControlStateNormal];
   // [cResultButton setBackgroundImage:greenButtonImage forState:UIControlStateHighlighted];
    [cResultButton setBackgroundColor:greenColor];
    [[cResultButton titleLabel] setFont:[UIFont boldSystemFontOfSize:13]];
    [pollCell addSubview:cResultButton];
    
    
    // D Results
    dResultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    float dRounded = [dVotes doubleValue] / totalVotes * 100;
   // [dResultButton setTitle:[NSString stringWithFormat:@"%.0f%%", roundf(dRounded)]forState:UIControlStateNormal];
    float dWidth;
    if ([dVotes doubleValue] == maxVotes) {
        dWidth = multFactor;
    } else {
        dWidth = ([cVotes doubleValue] / totalVotes) * multFactor + 10;
    }
    dPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xSpace+dWidth+5, 168, 35, 21)];
    [dPercentLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [dPercentLabel setText:[NSString stringWithFormat:@"%.0f%%", roundf(dRounded)]];
    [pollCell addSubview:dPercentLabel];
    dResultButton.frame = CGRectMake(xSpace, 168, dWidth, height);
   // [dResultButton setBackgroundImage:tanButtonImage forState:UIControlStateNormal];
   // [dResultButton setBackgroundImage:tanButtonImage forState:UIControlStateHighlighted];
    [dResultButton setBackgroundColor:orangeColor];
    [[dResultButton titleLabel] setFont:[UIFont boldSystemFontOfSize:13]];
    [pollCell addSubview:dResultButton];
    
    
    [pollLabel setText:[[self poll] objectForKey:@"poll"]];
    [refreshControl endRefreshing];
    //[self hasUserVoted];
}

-(NSNumber *)calculateWidth:(float)percent
{
    if (percent < .25) {
        return [NSNumber numberWithFloat:98.0 + 10 + 10] ;
    } else if ( percent < .30) {
        return [NSNumber numberWithFloat:110.0];
    } else if ( percent < .50) {
        return [NSNumber numberWithFloat:140.0 + 10];
    } else if (percent < .75) {
        return [NSNumber numberWithFloat:210.0 + 10];
    } else if ( percent < .85) {
        return [NSNumber numberWithFloat:238 + 10];
    } else if (percent < .95) {
        return [NSNumber numberWithFloat:270 + 10];
    } else {
        return [NSNumber numberWithFloat:275 + 10];
    }
    
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
        WMNavigationController *loginNavigation = [[WMNavigationController alloc] initWithRootViewController:registerViewController];

        
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
    
    
    // Can add poll?
    NSString *userID = [[PFUser currentUser] objectId];
    if ([userID isEqualToString:@"TP1zH9PHeJ"] || [userID isEqualToString:@"wd8wxq46wl"]) {
        UIBarButtonItem *addPoll = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPoll)];
        [[self navigationItem] setRightBarButtonItem:addPoll];
    } else {
        [[self navigationItem] setRightBarButtonItem:nil];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

-(void)setUserName:(NSString *)userName
{
    [[[logInViewController logInView] usernameField] setText:userName];
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
    [self enableVoteButtons:NO];
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
    NSArray *resultButtons = [[NSArray alloc] initWithObjects:aResultButton, bResultButton, cResultButton, dResultButton, nil];
    NSArray *labels = [[NSArray alloc] initWithObjects:aLabel,bLabel,cLabel,dLabel, aPercentLabel, bPercentLabel, cPercentLabel, dPercentLabel, nil];
    if (voted) {
        for (UIButton *b in voteButtons) {
            [b setEnabled:NO];
            [b setHidden:YES];
        }
        for (UIButton *b in resultButtons) {
            [b setHidden:NO];
        }
        for (UILabel *label in labels) {
            [label setHidden:NO];
        }
        [voteLabel setText:[NSString stringWithFormat:@"Results (%d Votes)", [voteCount intValue]]];
       
    } else {
        for (UIButton *b in voteButtons) {

            [b setEnabled:YES];
            [b setHidden:NO];
        }
        for (UIButton *b in resultButtons) {
            [b setHidden:YES];
        }
        for (UILabel *label in labels) {
            [label setHidden:YES];
        }
        [voteLabel setText:@"Please Vote!"];
    }
}

// ABOUT BUTTON
- (IBAction)aboutAction:(id)sender
{
    UIStoryboard *about = [UIStoryboard storyboardWithName:@"WMAboutSection" bundle:nil];
    WMAboutSectionViewController *aboutViewController = [about instantiateViewControllerWithIdentifier:@"WMAboutSection"];
    [[self navigationController] pushViewController:aboutViewController animated:YES];
}

// FEEDBACK BUTTON
- (IBAction)feedbackAction:(id)sender
{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    [mailController setMailComposeDelegate:self];
    [mailController setSubject:@"White Mocha FEEDBACK"];
    [mailController setToRecipients:[[NSArray alloc] initWithObjects:@"liedtke15@up.edu",@"schumach15@up.edu", nil]];
    [self presentViewController:mailController animated:YES completion:NULL];    
}

// Compose email!
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)aAction:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMPoll"];
    [query whereKey:@"currentPoll" equalTo:[NSNumber numberWithBool:TRUE]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *updatePoll = objects[0];
            [updatePoll incrementKey:@"aVotes"];
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

- (IBAction)bAction:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMPoll"];
    [query whereKey:@"currentPoll" equalTo:[NSNumber numberWithBool:TRUE]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *updatePoll = objects[0];
            [updatePoll incrementKey:@"bVotes"];
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

- (IBAction)cAction:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMPoll"];
    [query whereKey:@"currentPoll" equalTo:[NSNumber numberWithBool:TRUE]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *updatePoll = objects[0];
            [updatePoll incrementKey:@"cVotes"];
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

- (IBAction)dAction:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMPoll"];
    [query whereKey:@"currentPoll" equalTo:[NSNumber numberWithBool:TRUE]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *updatePoll = objects[0];
            [updatePoll incrementKey:@"dVotes"];
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

// STUDY ROOM BUTTON
- (IBAction)studyAction:(id)sender
{
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *webview=[[UIWebView alloc]initWithFrame:screenFrame];
    NSString *url=@"http://up.libcal.com/mobile.php?action=8&tid=2306&d=2013-08-14&hs=r";
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webview loadRequest:nsrequest];
        [webview stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 5.0;"];
    UIViewController *webViewController = [[UIViewController alloc] init];
    [webViewController setTitle:@"Study Room"];
    
    [webViewController setView:webview];

    

    
    [[self navigationController] pushViewController:webViewController animated:YES];
}
@end
