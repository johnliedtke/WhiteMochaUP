//
//  WMEventDetailsViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/9/14.
//
//

#import "WMEventDetailsViewController.h"
#import "UIColor+WMColors.h"
#import "WMRecentCommentsViewController.h"
#import "WMEventDetailView.h"
#import "WMEventDetailTextCell.h"
#import "WMDetailCell.h"





@interface WMEventDetailsViewController ()


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WMEventDetailView *eventDetailView;
@property (strong, nonatomic) WMDetailCell *detailCell;
@property (strong, nonatomic) NSMutableDictionary *offscreenCells;




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

- (WMDetailCell *)detailCell
{
    if (!_detailCell) {
        WMDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"WMDetailCell"];
        //[cell configureWithThirdPartyObject:self.app];
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

    self.tableView.backgroundColor = [UIColor WMBackgroundColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMDetailCell" bundle:nil] forCellReuseIdentifier:@"WMDetailCell"];
    
    
    
   

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

#pragma mark - Table view data source

// Sections
const static int DETAILS_SECTION = 0;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Row height
const static int ANSWERS_SECTION = 0;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;


    
    return  height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 195.0;
}

// Header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

// Header height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    
    if (indexPath.section == DETAILS_SECTION) {
    cell = (WMEventDetailTextCell *)[tableView dequeueReusableCellWithIdentifier:@"WMDetailCell" forIndexPath:indexPath];
        [cell setEvent:self.event];
        

    }
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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


- (void)loadedComments:(CGRect)tableViewFrame
{



}


@end
