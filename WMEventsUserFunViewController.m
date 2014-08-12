//
//  WMEventsUserFunViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/27/14.
//
//

#import "WMEventsUserFunViewController.h"
#import "WMEventCell.h"
#import <Parse/Parse.h>
#import "WMEvents.h"
#import "WMEvent2.h"
#import "WMSegmentedControl.h"
#import "WMEventDetailsViewController.h"

#define FUN_SEGMENTED_INDEX 0
#define SUBSCRIBED_SEGMENT_INDEX 1

@interface WMEventsUserFunViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet WMSegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WMEvents *events;

@end

@implementation WMEventsUserFunViewController

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
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"WMEventCell" bundle:nil] forCellReuseIdentifier:@"WMEventCell"];
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.events;
    
    // Back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Refresh control
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    tableViewController.tableView = self.tableView;
    tableViewController.refreshControl = self.refreshControl;
    
    // Segmented control
    [self.segmentedControl addTarget:self
                              action:@selector(changeCategory)
                    forControlEvents:UIControlEventValueChanged];
    
    
    [self handleRefresh];

}

- (UIRefreshControl *)refreshControl
{
    if (!_refreshControl) { _refreshControl = [[UIRefreshControl alloc] init];}
    return _refreshControl;
}

- (WMEvents *)events
{
    if (!_events) _events = [[WMEvents alloc] init];
    return _events;
}



- (void)handleRefresh
{
    [self.refreshControl beginRefreshing];
    
    PFQuery *funQuery = [PFQuery queryWithClassName:@"WMEvent2"];
    [funQuery whereKey:@"category" equalTo:FUN_CATEGORY];
    
    PFQuery *subscriptionQuery = [PFQuery queryWithClassName:@"WMEvent2"];
    [subscriptionQuery whereKey:@"subCategory" containedIn:[WMSubscription subscriptionStrings]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[funQuery,subscriptionQuery]];
    combinedQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.events addEvents:objects];
        [self changeCategory];
        [self.refreshControl endRefreshing];
    }];
}

- (void)changeCategory
{
    __weak typeof(self) weakSelf = self;
    if (self.segmentedControl.selectedSegmentIndex == FUN_SEGMENTED_INDEX) {
        [self.events changeCategory:FUN_CATEGORY withBlock:^(BOOL success) {
            if (success) {
                [weakSelf.tableView reloadData];
            }
        }];
    } else {
        [self.events changeSubCategory:[WMSubscription subscriptionStrings] withBlock:^(BOOL success) {
            if (success) {
                [weakSelf.tableView reloadData];
            }
        }];
    }
    
    
}

- (NSString *)currentCategory
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            return ALL_CATEGORY;
            break;
        case 1:
            return SCHOOL_CATEGORY;
            break;
        case 2:
            return SPORTS_CATEGORY;
            break;
        case 3:
            return CLUBS_CATEGORY;
            break;
        default:
            return ALL_CATEGORY;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WMEventDetailsViewController *detailVC = [segue destinationViewController];
        detailVC.event = [[self.events.eventsDictionary objectForKey:self.events.dates[[indexPath section]]] objectAtIndex:[indexPath row]];
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
