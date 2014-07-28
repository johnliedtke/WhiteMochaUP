//
//  WMPollViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/1/14.
//
//

#import "WMPollViewController.h"
#import "WMPollAnswerTableViewCell.h"
#import "WMPollFooterView.h"
#import "WMPoll.h"
#import "WMPollAnswer.h"
#import "WMSocialTableViewCell.h"
#import "WMPollResultsViewController.h"
#import "WMCustomLoginViewController.h"
#import "WMNavigationController.h"
#import "UIViewController+WMChangeTabItems.h"

@interface WMPollViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WMPoll *poll;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIAlertView *confirmAletView;
@property (nonatomic) BOOL emailConfirmed;
@property (strong, nonatomic) IBOutlet UILabel *pollNumberLabel;

@end

@implementation WMPollViewController
const static int ROW_HEIGHT = 60;
//const static int FOOTER_HEIGHT = 1;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // View Setup
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"White Mocha";
    self.dateLabel.text = [WMPoll pollDate];
    // Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = self.refreshControl;
    [self.refreshControl addTarget:self
                            action:@selector(handleRefresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Log in stuff
    self.emailConfirmed = FALSE;
    
    // TableView background color
    UIColor *whiteKind = [[UIColor alloc] initWithRed:238.0/255.0
                                                green:238.0/255
                                                 blue:238.0/255
                                                alpha:1.0];
    
    self.tableView.backgroundColor = whiteKind;
    self.view.backgroundColor = whiteKind;
    self.tableView.separatorColor = [UIColor clearColor];
    
    // Menu Button
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(testResults)];
    [[self navigationItem] setLeftBarButtonItem:menuItem];
    
    
    // Load custom cells
    [self.tableView registerNib:[UINib nibWithNibName:@"WMPollAnswerTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"WMPollCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMSocialTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"WMSocialTableViewCell"];
    
    
    // Initalize the poll
    NSArray *answers = [WMPollAnswer createAnswersWithStringArray:@[@"Loading...",@"Loading", @"Loading...", @"Loading..."]];
    
    NSString *question = @"Loading question...";
    _poll = [[WMPoll alloc] initWithQuestion:question answers:answers];
    [self.refreshControl beginRefreshing];
    [self handleRefresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loginStuff];
    [self hasUserVoted];
}

- (void)testResults
{
    WMPollResultsViewController *pollResultsVC = [[WMPollResultsViewController alloc] init];
    pollResultsVC.poll = self.poll;
    //TestViewController *test = [[TestViewController alloc] init];
    [[self navigationController] pushViewController:pollResultsVC animated:YES];
    
}

#pragma mark - Table view data source

// Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? _poll.answers.count : 1;
}

// Row height
const static int ANSWERS_SECTION = 0;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ANSWERS_SECTION) {
        return ROW_HEIGHT;
    } else {
        return ROW_HEIGHT;
    }
}

// Header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        //WMPollFooterView *pollFooterView = [WMPollFooterView PollFooterView];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 5, 5)];
        [view setBackgroundColor:[UIColor clearColor]];
        return nil;//pollFooterView;
    }
}

// Header height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return  0.0;
    } else {
        return 0;//30.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // Answer Cells
    
    WMPollAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMPollCell" forIndexPath:indexPath];
        
//    UIColor * greenColor = [UIColor colorWithRed:11/255.0f green:211/255.0f blue:24/255.0f alpha:1.0f];
//    UIColor * blueColor = [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0f];
//    UIColor * redColor = [UIColor colorWithRed:255/255.0f green:19/255.0f blue:0/255.0f alpha:1.0f];
//    UIColor * purpleColor = [UIColor colorWithRed:198/255.0f green:67/255.0f blue:252/255.0f alpha:1.0f];
    
    switch (indexPath.row) {
        case 0:
            [cell.circleButton drawCircleButton:[WMPoll pollColor:3] title:[NSString stringWithFormat:@"%d", (int)indexPath.row+1]];
            break;
        case 1:
            [cell.circleButton drawCircleButton:[WMPoll pollColor:3] title:[NSString stringWithFormat:@"%d", (int)indexPath.row+1]];
            break;
        case 2:
            [cell.circleButton drawCircleButton:[WMPoll pollColor:3] title:[NSString stringWithFormat:@"%d", (int)indexPath.row+1]];
            break;
        case 3:
            [cell.circleButton drawCircleButton:[WMPoll pollColor:3] title:[NSString stringWithFormat:@"%d", (int)indexPath.row+1]];
            break;
        case 4:
            [cell.circleButton drawCircleButton:[WMPoll pollColor:3] title:[NSString stringWithFormat:@"%d", (int)indexPath.row+1]];
            break;
        default:
            break;
    }
        
        // Cell Labels
        cell.answerLabel.text = [_poll.answers[indexPath.row] answer];
        cell.votesLabel.text = [NSString stringWithFormat:@"%lu Votes",(unsigned long)[_poll.answers[indexPath.row] votes]];
        return cell;
    } else { // Social Cell
        WMSocialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMSocialTableViewCell" forIndexPath:indexPath];
        return  cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.poll isVotedUser:[PFUser currentUser]] && indexPath.section == ANSWERS_SECTION) {
        _confirmAletView = [[UIAlertView alloc] initWithTitle:[_poll.answers[indexPath.row] answer] message:@"Please confirm your vote." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        [_confirmAletView show];
        }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSIndexPath *answerIndexPath = [self.tableView indexPathForSelectedRow];
    if (alertView == _confirmAletView && buttonIndex == 1) {
        [self.poll userVotedAnswer:self.poll.answers[answerIndexPath.row] user:[PFUser currentUser]];
        [self hasUserVoted];
    } else {
        [self.tableView deselectRowAtIndexPath:answerIndexPath animated:YES];
    }
}



- (void)hasUserVoted
{
    if ([self.poll isVotedUser:[PFUser currentUser]]) {
        WMPollResultsViewController *pollResultsVC = [[WMPollResultsViewController alloc] init];
        pollResultsVC.poll = _poll;
        [self changeTabBarItems];
        [[self navigationController] pushViewController:pollResultsVC animated:NO];
    }
}

- (void)updateUI
{
    //[self.tableView reloadData];
    [_pollNumberLabel setText:[NSString stringWithFormat:@"Poll of the day #%d",(int)_poll.pollNumber]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
     self.questionLabel.text = self.poll.question;
    
}

- (void)handleRefresh
{
    [WMPoll fetchCurrentPoll:^(BOOL success, WMPoll *poll, NSError *error) {
        if (success) {
            self.poll = poll;
            [self.refreshControl endRefreshing];
            [self updateUI];
            [self hasUserVoted];
        }
    }];
}

# pragma mark - log in stuff

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
        [logInViewController setSignUpController:(PFSignUpViewController *)loginNavigation];
        [customLogin setSignUpController:(PFSignUpViewController *)loginNavigation];
        
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

-(void)checkEmailConfirmed
{
    if (!self.emailConfirmed) {
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
                self.emailConfirmed = TRUE;
            }
        }];
    }
}

-(void)setUserName:(NSString *)userName
{
    [[[logInViewController logInView] usernameField] setText:userName];
    [self dismissViewControllerAnimated:YES completion:nil];
}



// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
