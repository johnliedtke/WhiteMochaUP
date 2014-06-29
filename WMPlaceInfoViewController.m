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
#import "WMWebViewController.h"

@interface WMPlaceInfoViewController ()

@end

@implementation WMPlaceInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _doneLoading = false;
    _canEdit = false;
    
    // Add an edit button
    [self doneEditing];
    
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

// Edit stuff
- (void)allowEditing
{
    _canEdit = true;
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    [[self navigationItem] setRightBarButtonItem:_doneButton];
}

// Done editing
- (void)doneEditing
{
    _canEdit = false;
    _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(allowEditing)];
    [[self navigationItem] setRightBarButtonItem:_editButton];

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

//// Turn editing on/off
//- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
//{
//    if (_canEdit)
//        return path;
//    else
//        return nil;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMPlaceItem *placeItem = [[[self placeInfo] infoItems] objectAtIndex:[indexPath row]];
   // NSString *meow = [[[self placeInfo] website] itemTitle];
    if (_canEdit) {
        WMPlaceInfoEditViewController *placeInfoEditViewController = [[WMPlaceInfoEditViewController alloc] init];
        WMNavigationController *placeInfoEdittNavigation = [[WMNavigationController alloc] initWithRootViewController:placeInfoEditViewController];
                [placeInfoEditViewController setPlaceItem:placeItem];
        [placeInfoEditViewController setDelegate:self];
        [self setUpadteIndex:indexPath];
        [self presentViewController:placeInfoEdittNavigation animated:YES completion:nil];
    } else if ([[placeItem itemTitle] isEqualToString:[[[self placeInfo] website] itemTitle]]) {
        // Constructa URL wit the link string of the item
        NSURL *url = [NSURL URLWithString:[[[self placeInfo] website] itemContents]];
        
        // Contruct a request object with that URL
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        
        // Load the request inot the web view
        [_webViewController setSizeScreen:5.0];
        [[_webViewController webView] loadRequest:req];
        
        // Set zoom
        [[_webViewController webView] stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 5.0;"];
        
        // Set the title of the web view controller's navigation item
        [[_webViewController navigationItem] setTitle:@"Events"];
        
        // Push the web view controller onto the navigation stack - this implicitly
        // creates the web view controller's view the first through
        
        [[self navigationController] pushViewController:_webViewController animated:YES];

            
    }
}

- (void)doneEditingItem:(WMPlaceItem *)newItem
{
    if (newItem) {
        WMPlaceItem *placeItem = [[[self placeInfo] infoItems] objectAtIndex:[[self upadteIndex] row]];
        [placeItem setItemContents:[newItem itemContents]];
        [[self tableView] reloadData];

    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
