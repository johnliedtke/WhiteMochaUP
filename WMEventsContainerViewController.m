//
//  WMEventsContainerViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/26/14.
//
//

#import "WMEventsContainerViewController.h"
#import "WMSubscriptionViewController.h"
#import "WMEventsMainController.h"

@interface WMEventsContainerViewController ()
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRight;
@property (strong, nonatomic) WMContainerViewController *containerViewController;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeft;

@end

@implementation WMEventsContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)swiped:(id)sender
{
    if (sender == _swipeLeft) {
        NSLog(@"swiped left");
        if ([self.containerViewController.currentSegueIdentifier isEqualToString:MAIN_EVENTS_SEGUE]) {
            [self.containerViewController swapViewControllers:FUN_EVENTS_SEGUE];
        } else if ([self.containerViewController.currentSegueIdentifier isEqualToString:SUBSCRIPTION_EVENTS_SEGUE]) {
            [self.containerViewController swapViewControllers:MAIN_EVENTS_SEGUE];
        }
        
    } else if (sender == _swipeRight) {
        NSLog(@"SWIPED RIGHT");
        if ([self.containerViewController.currentSegueIdentifier isEqualToString:MAIN_EVENTS_SEGUE]) {
            [self.containerViewController swapViewControllers:SUBSCRIPTION_EVENTS_SEGUE];
        } else if ([self.containerViewController.currentSegueIdentifier isEqualToString:FUN_EVENTS_SEGUE]) {
            [self.containerViewController swapViewControllers:MAIN_EVENTS_SEGUE];
        }
    }
    
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.containerViewController = segue.destinationViewController;
    }
}


@end
