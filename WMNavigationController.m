//
//  WMNavigationController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 10/14/13.
//
//

#import "WMNavigationController.h"
#import "WMConstants.h"


@interface WMNavigationController ()

@end

@implementation WMNavigationController

- (id)init {
    self = [super initWithNavigationBarClass:[WMNavigationBar class] toolbarClass:nil];
    if(self) {
 
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[WMNavigationBar class] toolbarClass:nil];
    if(self) {
        self.viewControllers = @[rootViewController];
    }
    
    return self;
}

-(void)viewDidLoad
{
    //200,110,223
    //UIColor *ios7Purple = [[UIColor alloc] initWithRed:133.0/255.0 green:66.0/255.0 blue:167.0/223.0 alpha:1.0];
    UIColor *otherPurple = [[UIColor alloc] initWithRed:134.0/255.0 green:92.0/255.0 blue:168.0/255.0 alpha:1.0];
    [[self navigationBar] setTranslucent:NO];
    [[self navigationBar] setBarTintColor: otherPurple];
    [[self navigationBar]setTranslucent:NO];
    [[self navigationBar] setBarStyle:UIBarStyleBlack];
    [[self navigationBar] setTintColor:[UIColor whiteColor]];
    
}

@end
