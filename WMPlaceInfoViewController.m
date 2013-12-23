//
//  WMPlaceInfoViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/22/13.
//
//

#import "WMPlaceInfoViewController.h"
#import "WMPlaceInfo.h"
#import "WMPlaceItem.h"
#import "WMNavigationController.h"

@interface WMPlaceInfoViewController ()

@end

@implementation WMPlaceInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _doneLoading = false;
    
    PFQuery *query = [PFQuery queryWithClassName:@"WMPlaceInfo"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            [self setPlaceInfo:(WMPlaceInfo *)object];
            
            [PFObject fetchAllIfNeededInBackground:[[self placeInfo] infoItems] block:^(NSArray *objects, NSError *error) {
                _doneLoading = true;
                [[self tableView] reloadData];
            }];
            
        
        }
    }];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self placeInfo] infoItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WMPlaceInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *descLabel = (UILabel *)[cell viewWithTag:101];
    if (_doneLoading) {
        WMPlaceItem *placeItem = [[[self placeInfo] infoItems] objectAtIndex:[indexPath row]];
        [nameLabel setText:[placeItem itemTitle]];
        [descLabel setText:[placeItem itemContents]];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMPlaceInfoEditViewController *placeInfoEditViewController = [[WMPlaceInfoEditViewController alloc] init];
    WMNavigationController *placeInfoEdittNavigation = [[WMNavigationController alloc] initWithRootViewController:placeInfoEditViewController];
    WMPlaceItem *placeItem = [[[self placeInfo] infoItems] objectAtIndex:[indexPath row]];
    [placeInfoEditViewController setPlaceItem:placeItem];
    [self presentViewController:placeInfoEdittNavigation animated:YES completion:nil];
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
