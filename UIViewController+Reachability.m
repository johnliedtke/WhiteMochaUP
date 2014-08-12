//
//  UIViewController+Reachability.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/3/14.
//
//

#import "UIViewController+Reachability.h"
#import "Reachability.h"

@implementation UIViewController (Reachability)

- (BOOL)isNetworkAvailable
{
    Reachability *networkReachability;
    NetworkStatus networkStatus;
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];

    return networkStatus != NotReachable;
}

@end
