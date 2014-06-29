//
//  WMPollResultsViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/7/14.
//
//

#import "WMPollResultsViewController.h"
#import "WMQuestionTableViewCell.h"
#import "WMPieChartTableViewCell.h"
#import "XYPieChart.h"
#import "WMAnswerLabelTableViewCell.h"
#import "UIViewController+WMChangeTabItems.h"
#import "WMPollViewController.h"
#import "WMCommentTableViewCell.h"
#import "WMComment.h"
#import "WMCommentsHeaderTableViewCell.h"
#import "WMCommentBar.h"
#import "WMCommentTextViewBar.h"
#import "WMAddCommentTableViewCell.h"
#import "WMCommentsViewController.h"

@interface WMPollResultsViewController ()

@property (nonatomic) int answerCount;
@property (nonatomic) BOOL toolBarVisible;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic) NSUInteger commentCount;
@end

@implementation WMPollResultsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // View stuff
    // Background
    UIColor *whiteKind = [[UIColor alloc] initWithRed:238.0/255.0
                                                green:238.0/255
                                                 blue:238.0/255
                                                alpha:1.0];
    self.tableView.backgroundColor = whiteKind;
    self.view.backgroundColor = whiteKind;
    self.tableView.separatorColor = [UIColor clearColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
 
    // Refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = self.refreshControl;
    [self.refreshControl addTarget:self
                            action:@selector(handleRefresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.edgesForExtendedLayout = UIRectEdgeNone;

//    WMPollAnswer *answer1 = [[WMPollAnswer alloc] initWithAnswer:@"Commons' fries"];
//    WMPollAnswer *answer2 = [[WMPollAnswer alloc] initWithAnswer:@"Cove Fries!"];
//    WMPollAnswer *answer3 = [[WMPollAnswer alloc] initWithAnswer:@"I'm a healthy person"];
//    WMPollAnswer *answer4 = [[WMPollAnswer alloc] initWithAnswer:@"I don't like either man"];
//    
//    WMPoll *newPoll = [[WMPoll alloc] initWithQuestion:@"What fries do you find most tantalizing?" answers:@[answer1,answer2,answer3,answer4]];
//    [WMComment addComment:@"Hello my dear friends" parent:newPoll];
//    [WMComment addComment:@"Cool poll fool" parent:newPoll];
//
//    [newPoll saveInBackground];

    // Table cells' nibs
    [self.tableView registerNib:[UINib nibWithNibName:@"WMQuestionTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"WMQuestionTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMPieChartTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"WMPieChartTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMAnswerLabelTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"WMAnswerLabelTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMCommentTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMCommentsHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMCommentsHeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMAddCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMAddCommentTableViewCell"];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChart reloadData];
    [self handleRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Results";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

const static int QUESTION_PIE_SECTION = 0;
const static int ANSWERS_SECTION = 1;
const static int COMMENT_HEADER_SECTION = 2;
const static int COMMENTS_SECTION = 3;
const static int COMMENTS_ADD_SECTION = 4;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == QUESTION_PIE_SECTION) { // Question and pie chart
        return 2;
    } else if (section == ANSWERS_SECTION) { // Answers
        return self.poll.answers.count;
    } else if (section == COMMENT_HEADER_SECTION) { // Comment header
        return 1;
    } else if (section == COMMENTS_SECTION) { // Comments
        return self.comments.count;
    } else if (section == COMMENTS_ADD_SECTION) {
        return 1;
    }
    return 0;
}


static const int QUESTION_ROW_HEIGHT = 72;
static const int PIE_CHART_HEIGHT = 275;
static const int ANSWER_LABEL_HEIGHT = 25;
static const int COMMENTS_HEADER_HEIGHT = 45;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == QUESTION_PIE_SECTION) {
        if ([indexPath row] == 0) {
            return QUESTION_ROW_HEIGHT;
        } else {
            return PIE_CHART_HEIGHT;
        }
    } else if (indexPath.section == ANSWERS_SECTION) {
        return ANSWER_LABEL_HEIGHT;
    } else if (indexPath.section == COMMENT_HEADER_SECTION) {
        return COMMENTS_HEADER_HEIGHT;
    } else if (indexPath.section == COMMENTS_SECTION) { // Comments
        return [[_comments objectAtIndex:indexPath.row] commentHeight];
    } else if (indexPath.section == COMMENTS_ADD_SECTION) {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == COMMENTS_ADD_SECTION) {
        return 20;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    
    if (indexPath.section == QUESTION_PIE_SECTION) {
        if (indexPath.row == 0) { // Question
            cell = [tableView dequeueReusableCellWithIdentifier:@"WMQuestionTableViewCell" forIndexPath:indexPath];
            [cell setPoll:_poll];
        } else if (indexPath.row == 1) { // Pie Chart
            cell = (WMPieChartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMPieChartTableViewCell" forIndexPath:indexPath];
            [[cell pieChart] setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            [[cell pieChart] setDelegate:self];
            [[cell pieChart] setDataSource:self];
            [[cell pieChart] reloadData];
            self.pieChart = [cell pieChart];
        }
    } else if (indexPath.section == ANSWERS_SECTION) { // Answers
        cell = (WMAnswerLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMAnswerLabelTableViewCell" forIndexPath:indexPath];
        [[cell colorIndicatorButton] setBackgroundColor:[WMPoll pollColor:indexPath.row]];
        [[cell answerLabel] setText:[self.poll.answers[indexPath.row] answer]];
        [[cell voteLabel] setText:[NSString stringWithFormat:@"%d Votes",(int)[self.poll.answers[indexPath.row] votes]]];
        
    } else if (indexPath.section == COMMENT_HEADER_SECTION) { // Comments Header
        cell = (WMCommentsHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMCommentsHeaderTableViewCell" forIndexPath:indexPath];
        if (_poll) {
            [[cell titleLabel] setText:[NSString stringWithFormat:@"Comments (%d)", _commentCount]];
        }
        [cell setDelegate:self];

    } else if (indexPath.section == COMMENTS_SECTION) { // Comments
        cell = (WMCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMCommentTableViewCell" forIndexPath:indexPath];
            [cell setComment:_comments[indexPath.row]];
        
    } else if (indexPath.section == COMMENTS_ADD_SECTION) { // Add comment
        cell = (WMAddCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMAddCommentTableViewCell" forIndexPath:indexPath];
    }
    return cell;
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.poll.answers.count;
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [self.poll.answers[index] votes];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index;
{
    return [WMPoll pollColor:index];
}

#pragma mark - Pie chart

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    for (int i = 0; i < _poll.answers.count; ++i) {
        [_pieChart setSliceDeselectedAtIndex:i];
    }
    [self. pieChart setSliceSelectedAtIndex:index];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:1] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    for (int i = 0; i < _poll.answers.count; ++i) {
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1] animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ANSWERS_SECTION) {
        for (int i = 0; i < self.poll.answers.count; ++i) {
            [self.pieChart setSliceDeselectedAtIndex:i];
        }
        [self.pieChart setSliceSelectedAtIndex:indexPath.row];
    } else if (indexPath.section == COMMENT_HEADER_SECTION) {
        [self showComments:NO];
    } else if (indexPath.section == COMMENTS_ADD_SECTION) {
        [self showComments:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ANSWERS_SECTION) {
        for (int i = 0; i < self.poll.answers.count; ++i) {
            [self.pieChart setSliceDeselectedAtIndex:i];
        }
    }
}

//
// End pie chart
//

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
    }
}
- (void)updateUI
{
    [self.pieChart reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfSections)] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)handleRefresh
{
    [[WMPoll currentPollQuery] getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            self.poll = (WMPoll *)object;
            [[WMComment fetchFiveComments:_poll] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    [self.refreshControl endRefreshing];
                    [self updateUI];
                    [self hasUserVoted];
                    [self.comments removeAllObjects];
                    [self.comments addObjectsFromArray:objects];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:COMMENTS_SECTION] withRowAnimation:UITableViewRowAnimationFade];
                }
            }];
            [[WMComment countComments:_poll] countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                if (!error) {
                    _commentCount = number;
                }
            }];
        }
    }];
}


- (void)hasUserVoted
{
    if (![self.poll isVotedUser:[PFUser currentUser]]) {
        WMPollViewController *pollViewContoller = [[WMPollViewController alloc] init];
        [self changeTabBarItems];
        [self.navigationController pushViewController:pollViewContoller animated:YES];
    }
}

/*
 * Comment Methods
 *
 */
#pragma mark - Comment Methods

- (void)showComments:(BOOL)showKeyboard
{
    WMCommentsViewController *commentsVC = [[WMCommentsViewController alloc] initWithParent:_poll];
    [commentsVC setParent:_poll];
    if (showKeyboard) {
        [commentsVC.commentBar.textView becomeFirstResponder];
        [commentsVC setShowKeyboardOnLoad:YES];
    }
    [self.navigationController pushViewController:commentsVC animated:YES];
}

- (NSMutableArray *)comments
{
    if (!_comments) _comments = [[NSMutableArray alloc] init];
    return _comments;
}

- (void)viewAllPressed
{
    [self showComments:NO];
}

// End comment methods





@end
