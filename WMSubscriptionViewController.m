//
//  WMSubscriptionViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/25/14.
//
//

#import "WMSubscriptionViewController.h"
#import "WMArrayDataSource.h"
#import "WMSubscription.h"
#import "WMEventSubscriptionCell.h"
#import "WMEditSubscriptionController.h"
#import <Parse/Parse.h>

#define EDIT_SUBSCRIPTION_SEGUE @"editSubscriptionSegue"

@interface WMSubscriptionViewController ()

@property (nonatomic, strong) WMArrayDataSource *subscriptionDataSource;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WMSubscriptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.tableView.dataSource = self.subscriptionDataSource;
    
    // Cells
    [self.tableView registerNib:[UINib nibWithNibName:@"WMEventSubscriptionCell" bundle:nil]
         forCellReuseIdentifier:@"WMEventSubscriptionCell"];

    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[PFInstallation currentInstallation] isDirty]) {
        [[PFInstallation currentInstallation] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                [self updateDataSource];
                [self.tableView reloadData];
            }
        }];
    } else {
        [[PFInstallation currentInstallation] refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                [self updateDataSource];
                [self.tableView reloadData];
            }
        }];
    }
}

- (WMArrayDataSource *)subscriptionDataSource
{
    if (!_subscriptionDataSource) {
        _subscriptionDataSource = [[WMArrayDataSource alloc] init];
        _subscriptionDataSource.delegate = self;
        [self updateDataSource];
    }
    return _subscriptionDataSource;
}

- (void)updateDataSource
{
    [self.subscriptionDataSource removeAllItems];
    [self.subscriptionDataSource addItems:[WMSubscription subscriptions]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)cellForItem:(id)item forIndexPath:(NSIndexPath *)indexPath
{
    WMEventSubscriptionCell *cell = (WMEventSubscriptionCell *)[self.tableView dequeueReusableCellWithIdentifier:@"WMEventSubscriptionCell" forIndexPath:indexPath];
    [cell setSubscription:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:EDIT_SUBSCRIPTION_SEGUE sender:self];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Delegate

- (void)updateUI
{
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:EDIT_SUBSCRIPTION_SEGUE]) {
        WMEditSubscriptionController *editVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [editVC setSubscription:[self.subscriptionDataSource itemAtIndex:indexPath.row]];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
