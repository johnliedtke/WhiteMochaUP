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
    [[self navigationBar] setTranslucent:NO];
    [[self navigationBar] setBarTintColor:PURPLECOLOR];
    [[self navigationBar]setTranslucent:NO];
    [[self navigationBar] setBarStyle:UIBarStyleBlack];
    [[self navigationBar] setTintColor:[UIColor whiteColor]];
    
}

@end
