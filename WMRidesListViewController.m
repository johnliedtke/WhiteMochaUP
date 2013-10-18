//
//  WMRidesListViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/10/13.
//
//

#import "WMRidesListViewController.h"
#import "WMListingCategoryViewController.h"
#import "WMRidesCell.h"
#import "WMRideDetailViewController.h"
#import "WMConstants.h"

@interface WMRidesListViewController ()

@end

@implementation WMRidesListViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        [self setParseClassName:@"WMRide"];
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"title";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
        
        // Set Title
        [self setTitle:@"Marketplace"];
        
        // Appearance
        PURPLEBACK
        [[[self navigationItem] leftBarButtonItem] setTintColor:PURPLECOLOR];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self tableView] registerNib:[UINib nibWithNibName:@"WMRidesCell" bundle:nil]
           forCellReuseIdentifier:@"WMRidesCell"];
    
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(listFurniture)];
    [[self navigationItem] setRightBarButtonItem:listButton];
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)listFurniture
{
    UIStoryboard *storyEvent = [UIStoryboard storyboardWithName:@"WMListingCatgeoryView" bundle:nil];
    WMListingCategoryViewController *lcvc= [storyEvent instantiateViewControllerWithIdentifier:@"WMListingCatgeoryView"];
    [[self navigationController] pushViewController:lcvc animated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

/* Delete listing */
- (void)deleteRide:(PFObject *)ride
{
    [ride deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        UIAlertView *av;
        if (succeeded) {
            av = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your listing has been sucessfully deleted." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        } else if (error) {
            av = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        }
        [av show];
    }];
    [self loadObjects];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

/*
 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
 PFQuery *query = [PFQuery queryWithClassName:[self parseClassName]];
 [query whereKey:@"course" equalTo:[[self courseInfo] objectForKey:@"course"]];
 
 // If Pull To Refresh is enabled, query against the network by default.
 if (self.pullToRefreshEnabled) {
 query.cachePolicy = kPFCachePolicyNetworkOnly;
 }
 
 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.
 if (self.objects.count == 0) {
 query.cachePolicy = kPFCachePolicyCacheThenNetwork;
 }
 
 [query orderByDescending:@"createdAt"];
 
 return query;
 }
 */

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"WMRidesCell";
    
    // Our custom cell!! :D
    WMRidesCell *cell = (WMRidesCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // To / From label
    [[cell toLabel] setText:[object objectForKey:@"to"]];
    [[cell fromLabel] setText:[object objectForKey:@"from"]];
    
    // Format date string
    NSDate *listdate = [object objectForKey:@"departureDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d h:mm a"];
    NSString *theDate = [dateFormatter stringFromDate:listdate];
    [[cell dateLabel] setText:theDate];
    

    // Cell background color;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDataSource


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if ([indexPath row] > self.objects.count -1 ) {
        return;
    }
    PFObject *listing = [self objectAtIndexPath:indexPath];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"WMRideDetailView" bundle:nil];
    WMRideDetailViewController *detailViewController = [story instantiateViewControllerWithIdentifier:@"WMRideDetailView"];
    [detailViewController setRide:listing];
    [detailViewController setDelegate:self];
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

/* Delete listing */
- (void)deleteListing:(PFObject *)listing
{
    [listing deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self loadObjects];
            NSLog(@"success");
        } else if (error) {
            NSLog(@"Error");
            [self loadObjects];
        }
    }];
}

// Weird color maker method
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
