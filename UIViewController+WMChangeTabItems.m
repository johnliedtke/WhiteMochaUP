//
//  UIViewController+WMChangeTabItems.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/8/14.
//
//

#import "UIViewController+WMChangeTabItems.h"
#import "WMPollViewController.h"
#import "WMPollResultsViewController.h"

@implementation UIViewController (WMChangeTabItems)

- (void)changeTabBarItems
{
    if ([self isMemberOfClass:[WMPollResultsViewController class]] || [self isMemberOfClass:[WMPollViewController class]]) {
        
        UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[[UIImage imageNamed:@"home_new.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
        [homeItem setSelectedImage:[[UIImage imageNamed:@"home_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        NSMutableArray *savedViewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        
        id viewController;
        if ([self isMemberOfClass:[WMPollViewController class]]) {
            viewController = [[WMPollResultsViewController alloc] init];
        } else {
            viewController = [[WMPollViewController alloc] init];
        }
        
        savedViewControllers[0] = viewController;
        [viewController setTabBarItem:homeItem];
        self.navigationController.viewControllers = savedViewControllers;
    }
}

@end
