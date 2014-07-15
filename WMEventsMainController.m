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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"purple_navbar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    [self.segmentedControl addTarget:self
                         action:@selector(changeCategory)
               forControlEvents:UIControlEventValueChanged];
    
    [self followScrollView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self handleRefresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:NO];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _events.dates.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _events.dates[section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 25)];
    [view setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 1, self.tableView.bounds.size.width-15, 20)];
    [label setText:[NSString stringWithFormat:@"%@",_events.dates[section]]];
    [label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [label setFont:[UIFont boldSystemFontOfSize:14.0]];
    [label setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_events.eventsDictionary objectForKey:_events.dates[section]] count];
}

- (void)handleRefresh
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMEvent2"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", [objects[0] title]);
        __weak typeof(self) weakSelf = self;
        [self.events addEvents:objects];
        [self.events changeCategory:[self currentCategory] withBlock:^(BOOL success) {
            [weakSelf.tableView reloadData];
        }];
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // Our custom cell!! :D
    WMEventCell *cell = (WMEventCell *)[tableView dequeueReusableCellWithIdentifier:@"WMEventCell"];
    
    WMEvent2 *event = [[_events.eventsDictionary objectForKey:_events.dates[[indexPath section]]] objectAtIndex:[indexPath row]];
    
    // Title
    [[cell titleLabel] setText:[event title]];
    
    // Date
    
    // Location
    [[cell locationLabel] setText:[event location]];
    
    
    return cell;
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
    }
    return ALL_CATEGORY;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMEventDetailsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"WMEventDetails"];
    [self.navigationController pushViewController:newView animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


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
