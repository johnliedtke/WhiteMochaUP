//
//  WMRightSegue.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/25/14.
//
//

#import "WMRightSegue.h"

@implementation WMRightSegue


- (void)perform
{
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];

    CATransition* transition = [CATransition animation];
    transition.duration = .25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromRight; //kCATransitionMoveIn; //, kCATransitionPush,   kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom



    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];

    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
}

@end
