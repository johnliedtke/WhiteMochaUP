//
//  WMEventsMainController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/6/14.
//
//

#import "WMEventsMainController.h"
#import "WMEvent2.h"
#import "WMEventCell.h"
#import "UIViewController+ScrollingNavbar.h"
#import "WMEvents.h"
#import "WMEventDetailsViewController.h"

@interface WMEventsMainController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) WMEvents *events;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation WMEventsMainController


- (WMEvents *)events
{
    if (!_events) _events = [[WMEvents alloc] init];
    return _events;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    
    [self followScrollView:self.tableView];
    [self handleRefresh];
}

- (UIRefreshControl *)refreshControl
{
    if (!_refreshControl) { _refreshControl = [[UIRefreshControl alloc] init];}
    return _refreshControl;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:NO];
}

- (void)handleRefresh
{
    [self.refreshControl beginRefreshing];
    PFQuery *query = [PFQuery queryWithClassName:@"WMEvent2"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        __weak typeof(self) weakSelf = self;
        [self.events addEvents:objects];
        [self.events changeCategory:[self currentCategory] withBlock:^(BOOL success) {
            [weakSelf.tableView reloadData];
        }];
        [self.refreshControl endRefreshing];
    }];
}

- (void)changeCategory
{
    __weak typeof(self) weakSelf = self;
    [self.events changeCategory:[self currentCategory] withBlock:^(BOOL success) {
        if (success) {
            [weakSelf.tableView reloadData];
        }
    }];
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


@end
