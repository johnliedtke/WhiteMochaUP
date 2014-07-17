//
//  WMTestViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/16/14.
//
//

#import "WMTestViewController.h"

@interface WMTestViewController ()
@property (strong, nonatomic) IBOutlet UIView *theView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *theViewHeight;

@end

@implementation WMTestViewController

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
    // Do any additional setup after loading the view.
    
    self.theViewHeight.constant = 1000;
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
