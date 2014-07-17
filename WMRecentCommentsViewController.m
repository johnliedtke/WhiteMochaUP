//
//  WMRecentCommentsViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/12/14.
//
//

#import "WMRecentCommentsViewController.h"
#import "WMComment.h"
#import "WMCommentTableViewCell.h"
#import "WMCommentsHeaderTableViewCell.h"
#import "WMAddCommentTableViewCell.h"


@interface WMRecentCommentsViewController ()

@property (nonatomic, strong) NSMutableArray *comments;

@end

@implementation WMRecentCommentsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    
    self = [super initWithStyle:style];
    if (self) {
        self.view.translatesAutoresizingMaskIntoConstraints = NO;

         }
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self.tableView registerNib:[UINib nibWithNibName:@"WMCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMCommentTableViewCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"WMCommentsHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMCommentsHeaderTableViewCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"WMAddCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMAddCommentTableViewCell"];
        self.view.translatesAutoresizingMaskIntoConstraints = NO;

    }
    
    return self;
}

- (NSMutableArray *)comments
{
    if (!_comments) _comments = [NSMutableArray array];
    return _comments;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // TableView background color
    UIColor *whiteKind = [[UIColor alloc] initWithRed:238.0/255.0
                                                green:238.0/255
                                                 blue:238.0/255
                                                alpha:1.0];
    
    self.tableView.backgroundColor = whiteKind;
    self.tableView.scrollEnabled = NO;
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"WMPoll2"];
    [query whereKey:@"currentPoll" equalTo:[NSNumber numberWithBool:true]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        _parent = object;
        [self handleRefresh];
        
    }];
    
    // Comment Cells
    [self.tableView registerNib:[UINib nibWithNibName:@"WMCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMCommentTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMCommentsHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMCommentsHeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMAddCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMAddCommentTableViewCell"];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleRefresh
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMComment"];
    [query includeKey:@"user"];
    [query whereKey:@"parent" equalTo:_parent];
    query.limit = 3;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.comments addObjectsFromArray:objects];
            [self.tableView reloadData];
            [self.delegate loadedComments:CGRectMake(0, 0, 0, 0)];
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

const static int COMMENT_HEADER_SECTION = 0;
const static int COMMENTS_SECTION = 1;
const static int COMMENTS_ADD_SECTION = 2;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == COMMENTS_SECTION) {
        return self.comments.count;
    } else {
        return 1;
    }
}

static const int COMMENTS_HEADER_HEIGHT = 45;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == COMMENT_HEADER_SECTION) {
        return COMMENTS_HEADER_HEIGHT;
    } else if (indexPath.section == COMMENTS_SECTION) { // Comments
        return [[_comments objectAtIndex:indexPath.row] commentHeight];
    } else if (indexPath.section == COMMENTS_ADD_SECTION) {
        return 50;
    }
    return 10;

}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == COMMENTS_ADD_SECTION) {
        return 20;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    
 if (indexPath.section == COMMENT_HEADER_SECTION) { // Comments Header
    cell = (WMCommentsHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMCommentsHeaderTableViewCell" forIndexPath:indexPath];
    //if (_poll) {
        [[cell titleLabel] setText:[NSString stringWithFormat:@"Comments (%d)", 0]];
    //}
    [cell setDelegate:self];
    
} else if (indexPath.section == COMMENTS_SECTION) { // Comments
    cell = (WMCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMCommentTableViewCell" forIndexPath:indexPath];
    [cell setComment:_comments[indexPath.row]];
    
} else if (indexPath.section == COMMENTS_ADD_SECTION) { // Add comment
    cell = (WMAddCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMAddCommentTableViewCell" forIndexPath:indexPath];
}

    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    
}


@end
