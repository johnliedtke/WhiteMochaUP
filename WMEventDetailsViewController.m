//
//  WMEventDetailsViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/9/14.
//
//

#import "WMEventDetailsViewController.h"
#import "UIViewController+WMComments.h"
#import "UIColor+WMColors.h"
#import "WMRecentCommentsViewController.h"
#import "WMEventDetailView.h"
#import "WMDetailCell.h"
#import "WMEventSubscribeCell.h"
#import "WMSubscription.h"
#import "UIFont+FlatUI.h"

@interface WMEventDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WMEventDetailView *eventDetailView;
@property (strong, nonatomic) WMDetailCell *detailCell;
@property (strong, nonatomic) NSMutableDictionary *offscreenCells;
@property (strong, nonatomic) WMSubscription *subscription;

@end

@implementation WMEventDetailsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (WMEventDetailView *)eventDetailView
{
    if (!_eventDetailView) _eventDetailView = [WMEventDetailView initView];

    return _eventDetailView;
}

- (NSMutableDictionary *)offscreenCells
{
    if (!_offscreenCells) _offscreenCells = [NSMutableDictionary dictionary];
    return _offscreenCells;
}

- (WMSubscription *)subscription
{
    if (!_subscription) _subscription = [[WMSubscription alloc] initWithSubscription:self.event.subCategory];
    return _subscription;
}

- (void)setEvent:(WMEvent2 *)event
{
    _event = event;
    self.navigationItem.title = _event.title;
    [self setCommentParent:_event.commentPointer];
    //[self fetchComments:self.tableView];
    
//    self.title = _event.title;
//    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
//    tlabel.text=self.navigationItem.title;
//    tlabel.textColor=[UIColor whiteColor];
//    tlabel.font = [UIFont flatFontOfSize:18.0];
//    tlabel.backgroundColor =[UIColor clearColor];
//    tlabel.adjustsFontSizeToFitWidth=YES;
//    self.navigationItem.titleView=tlabel;


}

- (WMDetailCell *)detailCell
{
    if (!_detailCell) {
        WMDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"WMDetailCell"];
        [cell layoutIfNeeded];
    }
    return _detailCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100; // set to whatever your "average" cell height is
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.backgroundColor = [UIColor WMBackgroundColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMDetailCell" bundle:nil] forCellReuseIdentifier:@"WMDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMEventSubscribeCell" bundle:nil] forCellReuseIdentifier:@"WMEventSubscribeCell"];
    
    [self fetchComments:self.tableView];
    
    if ([self.event.type isEqualToString:@"RSS"]) {
        [self setEnableComments:[NSNumber numberWithBool:FALSE]];
    }
    
    

    
    
    // Register Cells
    [self setUpCommentCells:self.tableView];
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


#pragma mark - Table view data source

// Sections
const static int DETAILS_SECTION = 0;
const static int SUBSCRIBE_SECTION = 1;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 + [self numberOfCommentSections];
}

// Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == DETAILS_SECTION)
        return 1;
    else if (section == SUBSCRIBE_SECTION)
        return [self.event hasSubCategory] ? 1 : 0;
    else
        return [self numberOfRowsInCommentSection:tableView inSection:section];
}

// Row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == DETAILS_SECTION) {
    
    NSString *rereuseIdentifier = @"WMDetailCell";
    
    
    WMDetailCell *cell = [self.offscreenCells objectForKey:@"WMDetailCell"];
    if (!cell) {
        cell = [WMDetailCell cellView];
        cell.event = _event;
        [self.offscreenCells setObject:cell forKey:rereuseIdentifier];
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    } else if (indexPath.section == SUBSCRIBE_SECTION) {
        height = 60.0;
    } else {
        return [self heightForCommentRow:tableView indexPath:indexPath];
    }
    
    return  height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 195.0;
}

// Header view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == SUBSCRIBE_SECTION) {
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

// Header height
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == SUBSCRIBE_SECTION) {
        return 0;
    } else return [self heightForCommentFooter:tableView inSection:section];
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    
    if (indexPath.section == DETAILS_SECTION) {
    cell = (WMDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"WMDetailCell" forIndexPath:indexPath];
        [cell setEvent:self.event];
        

    } else if (indexPath.section == SUBSCRIBE_SECTION) {
        cell = (WMEventSubscribeCell *)[tableView dequeueReusableCellWithIdentifier:@"WMEventSubscribeCell" forIndexPath:indexPath];
        [cell setSubscription:self.subscription];
    } else {
        return [self setUpCell:tableView indexPath:indexPath];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectCommentRow:tableView indexPath:indexPath];
}












- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}






@end
