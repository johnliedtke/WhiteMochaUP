//
//  WMFurnitureListingsViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/9/13.
//
//

#import "WMFurnitureListingsViewController.h"
#import "WMFurniture.h"
#import "WMFurnitureCell.h"
#import "WMListingCategoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WMGeneralDetailViewController.h"
#import "WMConstants.h"
#import "WMGeneralDViewController.h"



@implementation WMFurnitureListingsViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        [[self navigationItem] setTitle:@"Marketplace"];
        PURPLEBACK
        
        // The className to query on
        self.parseClassName = @"WMFurniture";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"title";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        self.imageKey = @"imageData";
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"WMFurnitureCell" bundle:nil]
                forCellReuseIdentifier:@"furnitureCell"];
     
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(listFurniture)];
    [listButton setTintColor:PURPLECOLOR];
    [[self navigationItem] setRightBarButtonItem:listButton];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] > self.objects.count -1 ) {
        return 40;
    }
    return 70;
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 
    
       static NSString *CellIdentifier = @"furnitureCell";


       // Our custom cell!! :D
        WMFurnitureCell *cell = (WMFurnitureCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       if (cell == nil) {
            cell = [[WMFurnitureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

       // Give it some love
        [[cell title] setText:[object objectForKey:@"title"]];

    // Manipulate price string
        NSString *price = [NSString stringWithFormat:@"$%@", [object objectForKey:@"price"]];
        [[cell price] setText:price];

        // Format date string
        NSDate *listdate = [object objectForKey:@"listDate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       [dateFormatter setDateFormat:@"M/d"];
        NSString *theDate = [dateFormatter stringFromDate:listdate];
       [[cell listDate] setText:theDate];


       // Add the image from the arousing cloud
        // Loads like a sexy tiger
       cell.furnitureImage.file = [object objectForKey:self.imageKey];
        [[cell furnitureImage] loadInBackground];

    return cell;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if ([indexPath row] > self.objects.count -1 ) {
        return;
    }




    	PFObject *currentFurniture = [self objectAtIndexPath:indexPath];
    
    
        // Create the detail view
        //    WMGeneralDetailViewController *detailViewController = [[WMGeneralDetailViewController alloc] init];
        //    [detailViewController setFurniture:currentFurniture];
        //    [detailViewController setGeneralListingDelegate:self];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"WMGeneralDetailView" bundle:nil];
       WMGeneralDViewController *generalDetailViewController = [story instantiateViewControllerWithIdentifier:@"WMGeneralDetailView"];
        [generalDetailViewController setListing:currentFurniture];
        [generalDetailViewController setGeneralListingDelegate:self];

        // PUSH IT ON!
       [[self navigationController] pushViewController:generalDetailViewController animated:YES];
        
    
    

}


- (void)listFurniture
{
    UIStoryboard *storyEvent = [UIStoryboard storyboardWithName:@"WMListingCatgeoryView" bundle:nil];
    WMListingCategoryViewController *lcvc= [storyEvent instantiateViewControllerWithIdentifier:@"WMListingCatgeoryView"];
    [[self navigationController] pushViewController:lcvc animated:YES];
}



///* Delete listing */
- (void)deleteListing:(PFObject *)furniture
{
    [furniture deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self loadObjects];
            NSLog(@"success");
        } else if (error) {
            NSLog(@"Error");
        }
    }];
}



















































//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom the table
//        
//        // The className to query on
//        self.parseClassName = @"WMFurniture";
//        
//        // The key of the PFObject to display in the label of the default cell style
//        self.textKey = @"title";
//        
//        // Whether the built-in pull-to-refresh is enabled
//        self.pullToRefreshEnabled = YES;
//        
//        // Whether the built-in pagination is enabled
//       self.paginationEnabled = YES;
//        
//        // The number of objects to show per page
//        self.objectsPerPage = 5;
//    }
//    return self;
//}
//
//#pragma mark - View lifecycle
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [[self tableView] registerNib:[UINib nibWithNibName:@"WMFurnitureCell" bundle:nil]
//           forCellReuseIdentifier:@"furnitureCell"];
//    
//    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(listFurniture)];
//    [listButton setTintColor:PURPLECOLOR];
//    [[self navigationItem] setRightBarButtonItem:listButton];
//}
//
//
//- (void)listFurniture
//{
//    UIStoryboard *storyEvent = [UIStoryboard storyboardWithName:@"WMListingCatgeoryView" bundle:nil];
//    WMListingCategoryViewController *lcvc= [storyEvent instantiateViewControllerWithIdentifier:@"WMListingCatgeoryView"];
//    [[self navigationController] pushViewController:lcvc animated:YES];
//}
//
//
//
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//}
//
//
//- (void)didReceiveMemoryWarning
//{
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc that aren't in use.
//}
//
//#pragma mark - Parse
//
//- (void)objectsDidLoad:(NSError *)error {
//    [super objectsDidLoad:error];
//    
//    // This method is called every time objects are loaded from Parse via the PFQuery
//}
////- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    //return 70;
////}
//
///* Delete listing */
//- (void)deleteListing:(PFObject *)furniture
//{
//    [furniture deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            [self loadObjects];
//            NSLog(@"success");
//        } else if (error) {
//            NSLog(@"Error");
//        }
//    }];
//}
//
//- (void)objectsWillLoad {
//    [super objectsWillLoad];
//    
//    // This method is called before a PFQuery is fired to get more objects
//}
//
//
//// Override to customize what kind of query to perform on the class. The default is to query for
//// all objects ordered by createdAt descending.
//- (PFQuery *)queryForTable {
//    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
//    
//    // If no objects are loaded in memory, we look to the cache first to fill the table
//    // and then subsequently do a query against the network.
//    if ([self.objects count] == 0) {
//        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    }
//    
//    [query orderByAscending:@"title"];
//    
//    return query;
//}
//
//
//
//// Override to customize the look of a cell representing an object. The default is to display
//// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
////    static NSString *CellIdentifier = @"furnitureCell";
////    
////    
////    // Our custom cell!! :D
////    WMFurnitureCell *cell = (WMFurnitureCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
////    if (cell == nil) {
////        cell = [[WMFurnitureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
////    }
////    
////    // Give it some love
////    [[cell title] setText:[object objectForKey:@"title"]];
////    
////    // Manipulate price string
////    NSString *price = [NSString stringWithFormat:@"$%@", [object objectForKey:@"price"]];
////    [[cell price] setText:price];
////    
////    // Format date string
////    NSDate *listdate = [object objectForKey:@"listDate"];
////    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
////    [dateFormatter setDateFormat:@"M/d"];
////    NSString *theDate = [dateFormatter stringFromDate:listdate];
////    [[cell listDate] setText:theDate];
////    
////    
////    // Add the image from the arousing cloud
////    // Loads like a sexy tiger
////    cell.furnitureImage.file = [object objectForKey:self.imageKey];
////    [[cell furnitureImage] loadInBackground];
//    static NSString *CellIdentifier = @"NextPage";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = @"Load more...";
//    
//    return cell;
//}
//
//
///*
// // Override if you need to change the ordering of objects in the table.
// - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
// return [objects objectAtIndex:indexPath.row];
// }
// */
//
//
// // Override to customize the look of the cell that allows the user to load the next page of objects.
// // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
// - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
// static NSString *CellIdentifier = @"NextPage";
// 
// UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
// 
// if (cell == nil) {
// cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
// }
// 
// cell.selectionStyle = UITableViewCellSelectionStyleNone;
// cell.textLabel.text = @"Load more...";
// 
// return cell;
// }
// 
//
//#pragma mark - Table view data source
//
///*
// // Override to support conditional editing of the table view.
// - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
// {
// // Return NO if you do not want the specified item to be editable.
// return YES;
// }
// */
//
///*
// // Override to support editing the table view.
// - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
// {
// if (editingStyle == UITableViewCellEditingStyleDelete) {
// // Delete the row from the data source
// [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
// }
// else if (editingStyle == UITableViewCellEditingStyleInsert) {
// // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
// }
// }
// */
//
///*
// // Override to support rearranging the table view.
// - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
// {
// }
// */
//
///*
// // Override to support conditional rearranging of the table view.
// - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
// {
// // Return NO if you do not want the item to be re-orderable.
// return YES;
// }
// */
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//	PFObject *currentFurniture = [self objectAtIndexPath:indexPath];
//    
//    
//    // Create the detail view
//    //    WMGeneralDetailViewController *detailViewController = [[WMGeneralDetailViewController alloc] init];
//    //    [detailViewController setFurniture:currentFurniture];
//    //    [detailViewController setGeneralListingDelegate:self];
//    
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"WMGeneralDetailView" bundle:nil];
//    WMGeneralDViewController *generalDetailViewController = [story instantiateViewControllerWithIdentifier:@"WMGeneralDetailView"];
//    [generalDetailViewController setListing:currentFurniture];
//    [generalDetailViewController setGeneralListingDelegate:self];
//    
//    // PUSH IT ON!
//    [[self navigationController] pushViewController:generalDetailViewController animated:YES];
//    
//}
//
//// Weird color maker method
//-(UIColor*)colorWithHexString:(NSString*)hex
//{
//    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
//    
//    // String should be 6 or 8 characters
//    if ([cString length] < 6) return [UIColor grayColor];
//    
//    // strip 0X if it appears
//    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
//    
//    if ([cString length] != 6) return  [UIColor grayColor];
//    
//    // Separate into r, g, b substrings
//    NSRange range;
//    range.location = 0;
//    range.length = 2;
//    NSString *rString = [cString substringWithRange:range];
//    
//    range.location = 2;
//    NSString *gString = [cString substringWithRange:range];
//    
//    range.location = 4;
//    NSString *bString = [cString substringWithRange:range];
//    
//    // Scan values
//    unsigned int r, g, b;
//    [[NSScanner scannerWithString:rString] scanHexInt:&r];
//    [[NSScanner scannerWithString:gString] scanHexInt:&g];
//    [[NSScanner scannerWithString:bString] scanHexInt:&b];
//    
//    return [UIColor colorWithRed:((float) r / 255.0f)
//                           green:((float) g / 255.0f)
//                            blue:((float) b / 255.0f)
//                           alpha:1.0f];
//}


@end
