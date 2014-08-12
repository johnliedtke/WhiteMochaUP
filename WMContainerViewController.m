//
//  WMContainerViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/26/14.
//
//

#import "WMContainerViewController.h"
#import "WMEventsMainController.h"
#import "WMSubscriptionViewController.h"
#import "WMEventsUserFunViewController.h"

@interface WMContainerViewController ()

@property (strong, nonatomic, readwrite) NSString *currentSegueIdentifier;
@property (assign, nonatomic) BOOL transitionInProgress;
@property (strong, nonatomic) WMEventsMainController *eventsMainController;
@property (strong, nonatomic) WMSubscriptionViewController *eventsSubscriptionController;
@property (strong, nonatomic) WMEventsUserFunViewController *eventsFunViewController;
@property (nonatomic, readwrite) NSString *currentSegue;

@end

@implementation WMContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.transitionInProgress = NO;
    self.currentSegueIdentifier = MAIN_EVENTS_SEGUE;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    if ([segue.identifier isEqualToString:MAIN_EVENTS_SEGUE]) {
        self.eventsMainController = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:SUBSCRIPTION_EVENTS_SEGUE]) {
        self.eventsSubscriptionController = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:FUN_EVENTS_SEGUE]) {
        self.eventsFunViewController = segue.destinationViewController;
    }

    
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:MAIN_EVENTS_SEGUE]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.eventsMainController];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+100);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    else if ([segue.identifier isEqualToString:SUBSCRIPTION_EVENTS_SEGUE]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.eventsSubscriptionController];
    } else if ([segue.identifier isEqualToString:FUN_EVENTS_SEGUE]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.eventsFunViewController];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController
              toViewController:(UIViewController *)toViewController
{
    
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+100);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    CATransition* transition = [CATransition animation];
    transition.duration = .25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromLeft; //kCATransitionMoveIn; //, kCATransitionPush,   kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
//    CGFloat width = self.view.frame.size.width;
//    CGFloat height = self.view.frame.size.height + 100;
    
    
//    [self transitionFromViewController:fromViewController
//                      toViewController:toViewController
//                              duration:0.4
//                               options:UIViewAnimationOptionTransitionNone
//                            animations:^(void) {
//                                fromViewController.view.frame = CGRectMake(0 - width, 0, width, height);
//                                toViewController.view.frame = CGRectMake(0, 0, width, height);
//                            } 
//                            completion:^(BOOL finished){
//                            
//                                       [fromViewController removeFromParentViewController];
//                                        [toViewController didMoveToParentViewController:self];
//                                        self.transitionInProgress = NO;
//}
//     ];
    


    
    [self transitionFromViewController:fromViewController
                      toViewController:toViewController duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve   animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

- (void)swapViewControllers:(NSString *)segue
{
    
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    NSString *beforeSegueIdentifier = [self.currentSegueIdentifier copy];
    self.currentSegueIdentifier = segue;
    
    if (([self.currentSegueIdentifier isEqualToString:MAIN_EVENTS_SEGUE]) && self.eventsMainController && [ beforeSegueIdentifier isEqualToString:SUBSCRIPTION_EVENTS_SEGUE]) {
        [self swapFromViewController:self.eventsSubscriptionController toViewController:self.eventsMainController];
        return;
    }
    
    if (([self.currentSegueIdentifier isEqualToString:MAIN_EVENTS_SEGUE]) && self.eventsMainController && [beforeSegueIdentifier isEqualToString:FUN_EVENTS_SEGUE]) {
        [self swapFromViewController:self.eventsFunViewController toViewController:self.eventsMainController];
        return;
    }

    
    if (([self.currentSegueIdentifier isEqualToString:SUBSCRIPTION_EVENTS_SEGUE]) && self.eventsSubscriptionController) {
        self.currentSegue = SUBSCRIPTION_EVENTS_SEGUE;
        [self swapFromViewController:self.eventsMainController toViewController:self.eventsSubscriptionController];
        return;
    }
    
    if (([self.currentSegueIdentifier isEqualToString:FUN_EVENTS_SEGUE]) && self.eventsFunViewController) {
        self.currentSegue = FUN_EVENTS_SEGUE;
        [self swapFromViewController:self.eventsMainController toViewController:self.eventsFunViewController];
        return;
    }

    
    
    
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}



@end
