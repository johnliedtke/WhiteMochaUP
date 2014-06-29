//
//  WMCommentsViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/22/14.
//
//

#import "WMCommentsViewController.h"
#import "WMCommentTableViewCell.h"
#import "WMComment.h"
#import "WMCommentBar.h"

@interface WMCommentsViewController ()

@property (nonatomic, readwrite) WMCommentBar *commentBar;

@end

@implementation WMCommentsViewController

- (id)initWithParent:(PFObject *)parent
{
    self = [self initWithStyle:UITableViewStylePlain];
    
    if (self) {
        self.parent = parent;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {        
        // The className to query on
        self.parseClassName = @"WMComment";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
    
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        UIColor *whiteKind = [[UIColor alloc] initWithRed:238.0/255.0
                                                    green:238.0/255
                                                     blue:238.0/255
                                                    alpha:1.0];
        self.tableView.backgroundColor = whiteKind;
        self.view.backgroundColor = whiteKind;
        self.tableView.separatorColor = [UIColor clearColor];
        self.navigationItem.title = @"Comments";
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeFirstResponder)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        
  
    }
    return self;
}
-(void)changeFirstResponder
{
    [self.commentBar.commentTextViewBar.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)postButtonPressed:(NSString *)comment
{
    [WMComment addComment:comment parent:_parent withBlock:^(BOOL success, NSError *error) {
        if (success) {
            [self hideKeyboard];
            [self loadObjects];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        return [[[self objects] objectAtIndex:indexPath.row] commentHeight];
    } else return  50;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMCommentTableViewCell"];
    
    // Hiding keyboard/toolbar
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    // Comment Bar
    [_commentBar setDelegate:self];

    
//    UIToolbar *toolBar = self.navigationController.toolbar;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:NO];

    _commentBar = [[[UINib nibWithNibName:@"WMCommentBar" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    _commentBar.delegate = self;
    [self.navigationController.toolbar addSubview:_commentBar];
    
    // Show keyboard
    if (_showKeyboardOnLoad) {
        [_commentBar.textView becomeFirstResponder];
        _showKeyboardOnLoad = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];


}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_commentBar.textView resignFirstResponder];
    [_commentBar.commentTextViewBar.textView resignFirstResponder];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [[self.navigationController.toolbar subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
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


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
 PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
     if (_parent) {
         [query whereKey:@"parent" equalTo:_parent];
     }
     [query includeKey:@"user"];
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



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 //static NSString *CellIdentifier = @"Cell";
 
// PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
// if (cell == nil) {
// cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
// }
 
     // Configure the cell
     WMCommentTableViewCell *newCell = (WMCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMCommentTableViewCell"];
     [newCell setComment:(WMComment *)object];
 
 return newCell;
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


- (void)hideKeyboard
{
    [self.commentBar.commentTextViewBar.textView resignFirstResponder];
    [self.commentBar.commentTextViewBar.textView endEditing:YES];
    [self.commentBar.textView resignFirstResponder];
}




@end
