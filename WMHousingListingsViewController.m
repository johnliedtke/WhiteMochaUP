//
//  WMHousingListingsViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/5/13.
//
//

#import "WMHousingListingsViewController.h"
#import "WMGeneralDetailViewController.h"
#import "WMHousingCell.h"
#import "WMGeneralListingViewController.h"
#import "WMConstants.h"
#import "WMListingCategoryViewController.h"

@interface WMHousingListingsViewController ()

@end

@implementation WMHousingListingsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        PURPLEBACK
        [self setTitle:@"Marketplace"];
        
        // The className to query on
        [self setParseClassName:@"WMHousing"];
        
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
    [[self tableView] registerNib:[UINib nibWithNibName:@"WMHousingCell" bundle:nil]
           forCellReuseIdentifier:@"housingCell"];
    
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(listFurniture)];
    [[self navigationItem] setRightBarButtonItem:listButton];
    
    // Refresh objects on load
    [self loadObjects];
    
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

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"housingCell";
    
    // Our custom cell!! :D
    WMHousingCell *cell = (WMHousingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Give it some love
    [[cell descriptionText] setText:[object objectForKey:@"title"]];
    
    // Manipulate price string
    NSString *price = [NSString stringWithFormat:@"$%@", [object objectForKey:@"price"]];
    [[cell priceLabel] setText:price];
    
    // Format date string
    NSDate *listdate = [object objectForKey:@"listDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d"];
    NSString *theDate = [dateFormatter stringFromDate:listdate];
    [[cell dateLabel] setText:theDate];
    
    // Location for housing
    [[cell locationField] setText:[object objectForKey:@"location"]];
    
    // Add the image from the arousing cloud
    
    cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    PFFile *imageFileTest = [object objectForKey:@"imageData"];
    [imageFileTest getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        [[cell itemImage] setImage:[UIImage imageWithData:data]];
        cell.contentView.backgroundColor = [self colorWithHexString:@"f5f5f5"];
        //[[cell furnitureImage] setImage:[[cell imageView] image]];
    }];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}




#pragma mark - UITableViewDataSource


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if ([indexPath row] > self.objects.count -1 ) {
        return;
    }
    PFObject *listing = [self objectAtIndexPath:indexPath];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"WMGeneralDetailView" bundle:nil];
    WMGeneralDViewController *generalDetailViewController = [story instantiateViewControllerWithIdentifier:@"WMGeneralDetailView"];
    [generalDetailViewController setListing:listing];
    [generalDetailViewController setGeneralListingDelegate:self];
    
    // PUSH IT ON!
    [[self navigationController] pushViewController:generalDetailViewController animated:YES];
    
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
