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
#import "MBProgressHUD.h"
#import "UIColor+WMColors.h"
#import "UIViewController+ScrollingNavbar.h"
#import "UIViewController+WMComments.h"


@interface WMCommentsViewController ()

@property (nonatomic, readwrite) UIActionSheet *commentActionSheet;
@property (nonatomic, readwrite) NSIndexPath *actionIndexPath;


@property (nonatomic, readwrite) WMCommentBar *commentBar;
@property (nonatomic, readwrite) UILabel *noCommentsLabel;

@end

@implementation WMCommentsViewController

- (id)initWithParent:(PFObject *)parent
{
    self.parent = parent;
    self = [self initWithStyle:UITableViewStylePlain];
    
    if (self) {

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
        //[self followScrollView:self.tableView];

        
  
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
    [self addComment:comment parent:[self parent] withSelectors:@[@"hideKeyboard",@"loadObjects"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        return [[[self objects] objectAtIndex:indexPath.row] commentHeight];
    } else return  70;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEnableComments:[NSNumber numberWithBool:YES]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMCommentTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMCommentLoadMoreCell" bundle:nil] forCellReuseIdentifier:@"WMCommentLoadMoreCell"];
    
    // Hiding keyboard/toolbar
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    // Comment Bar
    [_commentBar setDelegate:self];
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    [self.tableView addGestureRecognizer:lpgr];


    
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
    [self updateCommentsLabel];


}


- (void)updateCommentsLabel
{
    if (self.objects.count == 0 && !self.isLoading) {
        [UIView animateWithDuration:2.0 delay:10 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
                    [self.view addSubview:_noCommentsLabel = [WMComment noCommentsLabel:CGRectMake(0.0, 150.0, self.view.bounds.size.width, 50)]];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [_noCommentsLabel removeFromSuperview];
    }
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
    [self showNavBarAnimated:NO];
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
     if (self.parent) {
         [query whereKey:@"parent" equalTo:_parent];
     } else {
     }
     [query includeKey:@"user"];
 // If Pull To Refresh is enabled, query against the network by default.
 if (self.pullToRefreshEnabled) {
     query.cachePolicy = kPFCachePolicyNetworkOnly;
 }
 
 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.
 if (self.objects.count == 0) {
     query.cachePolicy = kPFCachePolicyNetworkOnly;

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
     
     if (self.objects.count > 0) {
         [self updateCommentsLabel];

     }
     
     

 
 return newCell;
 }

-(void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (_commentActionSheet) {
        _commentActionSheet = nil;
    } else {
        CGPoint location = [longPress locationInView:self.tableView];
        _actionIndexPath = [self.tableView indexPathForRowAtPoint:location];
        WMComment *commentToDelete = [self objects][_actionIndexPath.row];
        if ([commentToDelete.user.objectId isEqualToString:[PFUser currentUser].objectId]) {
            
            
            
            _commentActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
            
//            for (UIView *subview in _commentActionSheet.subviews) {
//                if ([subview isKindOfClass:[UIButton class]]) {
//                    UIButton *button = (UIButton *)subview;
//                    if ([button.titleLabel.text isEqualToString:@"Cancel"]) {
//                        NSLog(@"wow");
//                    }
//                    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
//                    [[button titleLabel] setTextColor:[UIColor purpleColor]];
//                }
//            }
            
            
            [_commentActionSheet showFromTabBar:self.tabBarController.tabBar];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        WMComment *commentToDelete = [self objects][_actionIndexPath.row];
        
        [self deleteComment:commentToDelete withSelectors:@[@"loadObjects"]];

    }
    
}

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */


 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"WMCommentLoadMoreCell";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;

 return cell;
 }


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
    NSLog(@"selected");
}


- (void)hideKeyboard
{
    [self.commentBar.commentTextViewBar.textView resignFirstResponder];
    [self.commentBar.commentTextViewBar.textView endEditing:YES];
    [self.commentBar.textView resignFirstResponder];
}




@end
