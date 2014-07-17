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




@interface WMEventDetailsViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIButton *subscribeButton;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailTextViewHeight;
@property (strong, nonatomic) IBOutlet UIView *containerVeiw;

@property (strong, nonatomic) IBOutlet UIView *extraDetailsView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;
@property (strong, nonatomic) WMRecentCommentsViewController *recentComments;
@property (strong, nonatomic) IBOutlet UIView *theView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *theViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;

@end

@implementation WMEventDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailView.layer.borderWidth = 1.0;
    self.detailView.layer.borderColor = [UIColor WMBorderColor].CGColor;
    self.extraDetailsView.layer.borderWidth = 1.0;
    self.extraDetailsView.layer.borderColor = [UIColor WMBorderColor].CGColor;
    self.subscribeButton.layer.cornerRadius = 5.0;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;


    
    CALayer *borderBottom = [CALayer layer];
    
    borderBottom.frame = CGRectMake(0.0f, self.detailView.frame.size.height-1,self.detailView.frame.size.width-1, 10.0);
    
    
    borderBottom.backgroundColor = [UIColor blueColor].CGColor;
    [self.detailView.layer addSublayer:borderBottom];

    
    self.detailTextView.textContainer.lineFragmentPadding = 0;
    self.detailTextView.textContainerInset = UIEdgeInsetsZero;
    
    _recentComments = [[WMRecentCommentsViewController alloc] init];
    _commentsTableView.delegate = _recentComments;
    _commentsTableView.dataSource = _recentComments;

   
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];

    
    bottomBorder.frame = CGRectMake(1.0f, -2.0f, self.extraDetailsView.frame.size.width-2, 4.0f);
    
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    
    [self.extraDetailsView.layer addSublayer:bottomBorder];
    self.containerHeightConstraint.constant = 500;
    int what = (self.containerHeightConstraint.constant + self.detailTextView.frame.size.height);
//    self.scrollViewHeight.constant = 0;
    

    

    
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    //[_scrollView layoutIfNeeded];

    
   // self.containerHeightConstraint.constant = 800;
    
    

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    self.theViewHeight.constant = 600;
    [self.scrollView layoutIfNeeded];
    [self.theView updateConstraints];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString:@"recentCommentsSegue"]) {
        _recentComments = [segue destinationViewController];
        _recentComments.delegate = self;
        CGRect containerFrame = self.containerVeiw.frame;
        containerFrame.size = _recentComments.tableView.frame.size;
        containerFrame.size.height += 500;

        //self.containerVeiw.frame = containerFrame;
        
        self.theViewHeight.constant = 600;
        
   
        
    }
}


- (void)loadedComments:(CGRect)tableViewFrame
{
    NSLog(@"getting here");
    CGRect scrollViewFrame = self.scrollView.frame;
    scrollViewFrame.size.height += _recentComments.tableView.frame.size.height;
    [self.scrollView layoutIfNeeded];


}


@end
