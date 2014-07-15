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
@property (strong, nonatomic) IBOutlet WMRecentCommentsViewController *recentCommentsViewController;

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
    self.subscribeButton.layer.cornerRadius = 5.0;

   
    
    
    
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.detailTextViewHeight.constant = self.detailTextView.contentSize.height;
//    [self.detailTextView setNeedsDisplay];
//    [self.scrollView layoutIfNeeded];
//    [self.detailView layoutIfNeeded];
//    [self.detailTextView layoutIfNeeded];
    
//    CGRect textViewFrame = self.detailTextView.frame;
//    CGSize sizeThatShouldFit = [self.detailTextView sizeThatFits:textViewFrame.size];
//    textViewFrame.size.height = sizeThatShouldFit.height + 200;
//    self.detailTextView.frame = textViewFrame;

    
//    CGRect detailViewFrame = self.detailView.frame;
//    detailViewFrame.size.height += 200;
//    self.detailView.frame = detailViewFrame;
    


//    // Get size of textView
//    CGSize sizeThatShouldFitTextView = [_detailTextView sizeThatFits:self.detailTextView.frame.size];
//    CGRect copyTextView = _detailTextView.frame;
//    float textViewHeight = sizeThatShouldFitTextView.height;
//    copyTextView.size.height += textViewHeight + 1000;
//    self.detailTextView.frame = copyTextView;
//    
//    // Size of detailView
//    CGRect copyOfDetailView = self.detailView.frame;
//    copyOfDetailView.size.height += textViewHeight +1000;
//    self.detailView.frame = copyOfDetailView;
//    
//    // Content View
//    CGRect copyContentView = self.contentView.frame;
//    copyContentView.size.height += textViewHeight;
//    self.contentView.frame = copyContentView;
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
