//
//  WMEditSubscriptionController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/29/14.
//
//

#import "WMEditSubscriptionController.h"
#import <Parse/Parse.h>
#import "UIFont+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UIColor+WMColors.h"
#import "WMSubscription.h"

@interface WMEditSubscriptionController ()

@property (strong, nonatomic) IBOutlet FUISwitch *oNOf;

@property (strong, nonatomic) IBOutlet UILabel *enabledLabel;

@property (strong, nonatomic) IBOutlet UILabel *setFontLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

// Switches
@property (strong, nonatomic) IBOutlet FUISwitch *pushEnabledSwitch;
@property (strong, nonatomic) IBOutlet FUISwitch *pushTwentyFourHourSwitch;
@property (strong, nonatomic) IBOutlet FUISwitch *pushOneHourSwitch;
@property (strong, nonatomic) IBOutlet FUISwitch *pushThirtyMinuteSwitch;

@property (nonatomic, readwrite) BOOL isEditing;


@property (strong, nonatomic) IBOutletCollection(FUISwitch) NSArray *switches;

@end


@implementation WMEditSubscriptionController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addEditButton];
    self.isEditing = NO;
    [_pushEnabledSwitch setOn:[self.subscription isSubscribedToNotification:PUSH_NOTIFICATIONS_SUBSCRIPTION] animated:YES];
    
    self.navigationItem.title = self.subscription.title;


    for (FUISwitch *s in _switches) {
        s.onColor = [UIColor colorFromHexCode:@"0BD318"];
        s.offColor = [UIColor cloudsColor];
        s.onBackgroundColor = [UIColor cloudsColor];
        s.offBackgroundColor = [UIColor silverColor];
        s.offLabel.font = [UIFont boldFlatFontOfSize:14];
        s.offLabel.tintColor = [UIColor cloudsColor];
        s.onLabel.font = [UIFont boldFlatFontOfSize:14];
        s.delegate = self;
    }
    
    for (UILabel *l in _labels) {
        l.font = [UIFont flatFontOfSize:16.0];
    }


    
    self.view.backgroundColor = [UIColor WMBackgroundColor];
    self.tableView.backgroundColor = [UIColor WMBackgroundColor];
    _enabledLabel.font = [UIFont boldFlatFontOfSize:16.0];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)edit
{
    _isEditing = YES;
    [self setUpSwitches];
}

- (void)save
{
    [self enableSwitches:NO];
    [self updateSubscription];
    [self.subscription saveSubscription:self.view];
    
}

- (void)updateSubscription
{
    if (!_pushEnabledSwitch.on) {
        [self.subscription updateSubscriptionNotification:PUSH_NOTIFICATIONS_SUBSCRIPTION remove:YES];
        return;
    }
    [self.subscription updateSubscriptionNotification:PUSH_NOTIFICATIONS_SUBSCRIPTION remove:!_pushEnabledSwitch];
    [self.subscription updateSubscriptionNotification:TWENTY_FOUR_HOUR_SUBSCRIPTION remove:!_pushTwentyFourHourSwitch.on];
    [self.subscription updateSubscriptionNotification:ONE_HOUR_SUBSCRIPTION remove:!_pushOneHourSwitch.on];
    [self.subscription updateSubscriptionNotification:THIRTY_MINUTE_SUBSCRIPTION remove:!_pushThirtyMinuteSwitch.on];
}

- (void)subscriptionSaved:(BOOL)success
{
    if (success) {
        _isEditing = false;
    } else {
        [self enableSwitches:YES];
    }
    [self setUpSwitches];
}

- (void)switchChanged:(UIControl *)swch on:(BOOL)on
{
    if (swch == _pushEnabledSwitch) {
        [self setUpSwitches];
    }

}

- (void)enableSwitches:(BOOL)enable
{
    for (FUISwitch *s in _switches) {
        [s setUserInteractionEnabled:enable];
    }
}

- (void)turnSwitchesOn:(BOOL)on switches:(NSArray *)switches
{
    for (FUISwitch *s in switches) {
        [s setOn:on animated:YES];
    }
}

- (void)setUpSwitches
{
    if (self.isEditing) {
        [self enableSwitches:YES];
    }
    [_pushOneHourSwitch setOn:[self.subscription isSubscribedToNotification:ONE_HOUR_SUBSCRIPTION] animated:YES];
    [_pushTwentyFourHourSwitch setOn:[self.subscription isSubscribedToNotification:TWENTY_FOUR_HOUR_SUBSCRIPTION] animated:YES];
    [_pushOneHourSwitch setOn:[self.subscription isSubscribedToNotification:ONE_HOUR_SUBSCRIPTION] animated:YES];
    [_pushThirtyMinuteSwitch setOn:[self.subscription isSubscribedToNotification:THIRTY_MINUTE_SUBSCRIPTION] animated:YES];
    
    if (!_pushEnabledSwitch.on) {
        [_pushOneHourSwitch setUserInteractionEnabled:NO];
        [_pushThirtyMinuteSwitch setUserInteractionEnabled:NO];
        [_pushTwentyFourHourSwitch setUserInteractionEnabled:NO];
        [self turnSwitchesOn:NO switches:@[_pushOneHourSwitch, _pushThirtyMinuteSwitch, _pushTwentyFourHourSwitch]];
    }

}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40.0;
    }
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.tableView.bounds.size.width, 25.0)];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont flatFontOfSize:14.0];
    [label setText:@"PUSH NOTIFICATIONS"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 25.0)];
    [view addSubview:label];
    return view;
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

- (IBAction)meow:(id)sender {
}
@end
