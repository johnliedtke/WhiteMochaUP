//
//  WMSubscription.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/30/14.
//
//

#import "WMSubscription.h"
#import <Parse/Parse.h>
#import "Reachability.h"
#import "MBProgressHUD.h"

#define CHANNELS @"channels"

@interface WMSubscription ()

@property (nonatomic, readwrite) NSString *subscription;
@property (nonatomic, strong) Reachability *networkReachability;
@property (nonatomic, readwrite) NetworkStatus networkStatus;

@end

@implementation WMSubscription

- (instancetype)initWithSubscription:(NSString *)subscription
{
    if (self = [super init]) {
        _subscription = subscription;
        _title = [self createTitle:subscription];
    }
    
    return self;
}

- (NSString *)createTitle:(NSString *)title
{
    NSRegularExpression *regexp = [NSRegularExpression
                                   regularExpressionWithPattern:@"([a-z])([A-Z])"
                                   options:0
                                   error:NULL];
    NSString *newTitle = [regexp
                           stringByReplacingMatchesInString:title
                           options:0
                           range:NSMakeRange(0, title.length)
                           withTemplate:@"$1 $2"];
    return newTitle;
}

+ (NSArray *)subscriptions
{
    NSMutableArray *subs = [NSMutableArray array];
    PFInstallation *installation = [PFInstallation currentInstallation];
    for (NSString *s in installation.channels) {
        if (([s rangeOfString:@"_"].location == NSNotFound) && ![s isEqualToString:@""]) {
            WMSubscription *subscription = [[WMSubscription alloc] initWithSubscription:s];
            [subs addObject:subscription];
        }
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    [subs sortUsingDescriptors:@[sortDescriptor]];

    return subs;
}

+ (NSArray *)subscriptionStrings; // NSString
{
    NSMutableArray *subs = [NSMutableArray array];
    PFInstallation *installation = [PFInstallation currentInstallation];
    for (NSString *s in installation.channels) {
        if (([s rangeOfString:@"_"].location == NSNotFound) && ![s isEqualToString:@""]) {
            [subs addObject:s];
        }
    }
    
    return [subs sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];;
}

+ (BOOL)isSubscribedToSubscription:(NSString *)subscription
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    return [currentInstallation.channels containsObject:subscription];
}

- (Reachability *)networkReachability
{
    if (!_networkReachability) _networkReachability = [Reachability reachabilityForInternetConnection];
    return _networkReachability;
}

- (NetworkStatus)networkStatus
{
    return [self.networkReachability currentReachabilityStatus];
}

- (BOOL)addSubscription:(NSString *)subscription
       withNotification:(NSString *)notification
{
    if (self.networkStatus == NotReachable) {
        return false;
    }
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    NSString *subscriptionString = [self createSubscriptionString:subscription withNotification:notification];
    
    if (![installation.channels containsObject:self.subscription]) {
        [installation addUniqueObject:self.subscription forKey:CHANNELS];
        [installation saveInBackground];
    }
    
    if ([notification isEqualToString:STANDARD_SUBSCRIPTION]) {
        
        [installation addUniqueObject:[self createSubscriptionString:subscription withNotification:TWENTY_FOUR_HOUR_SUBSCRIPTION] forKey:CHANNELS];
        [installation saveInBackground];
        
        [installation addUniqueObject:[self createSubscriptionString:subscription withNotification:ONE_HOUR_SUBSCRIPTION] forKey:CHANNELS];
        [installation saveInBackground];
        
        [installation addUniqueObject:[self createSubscriptionString:self.subscription withNotification:PUSH_NOTIFICATIONS_SUBSCRIPTION] forKey:CHANNELS];
        [installation saveInBackground];
        
        return true;
    }

    [self createSubscriptionString:subscription withNotification:notification];
    [installation addUniqueObject:subscriptionString forKey:CHANNELS];
    [installation saveInBackground];
    [installation addUniqueObject:self.subscription forKey:self.subscription];
    
    return true;
}



- (BOOL)removeSubscription:(NSString *)subscription withNotification:(NSString *)notification
{
    if (self.networkStatus == NotReachable) {
        return false;
    }
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    
    // Remove all
    if ([notification isEqualToString:PUSH_NOTIFICATIONS_SUBSCRIPTION]) {
        for (NSString *s in [installation channels]) {
            if ([s rangeOfString:subscription].location != NSNotFound && ![s isEqualToString:self.subscription]) {
                [installation removeObject:s forKey:CHANNELS];
                [installation saveInBackground];
            }
        }
        return true;
    }
    
    NSString *subscriptionToRemove = [self createSubscriptionString:subscription withNotification:notification];
    [installation removeObject:subscriptionToRemove forKey:CHANNELS];
    [installation saveInBackground];
    
    return true;
}

- (BOOL)updateSubscriptionNotification:(NSString *)notification remove:(BOOL)remove;
{
    if (remove) {
        return [self removeSubscription:self.subscription withNotification:notification];
    } else {
       return [self addSubscription:self.subscription withNotification:notification];
    }
}

- (NSString *)createSubscriptionString:(NSString *)subscription
                      withNotification:(NSString *)notification
{
    return [NSString stringWithFormat:@"%@_%@",subscription,notification];

}


- (BOOL)isSubscribedToNotification:(NSString *)notification;
{
    PFInstallation *installation = [PFInstallation currentInstallation];

    if ([notification isEqualToString:PUSH_NOTIFICATIONS_SUBSCRIPTION]) {
        if ([installation.channels containsObject:[self createSubscriptionString:self.subscription withNotification:PUSH_NOTIFICATIONS_SUBSCRIPTION]]) {
            return true;
        }
        return false;
    }
    
    NSString *subscriptionString = [self createSubscriptionString:self.subscription withNotification:notification];
    
    for (NSString *s in [installation channels]) {
        if ([subscriptionString isEqualToString:s]) {
            return true;
        }
    }
    
    return false;
}

- (BOOL)deleteSubscription
{
    if (self.networkStatus == NotReachable) {
        return false;
    }
    
    [self removeSubscription:self.subscription withNotification:PUSH_NOTIFICATIONS_SUBSCRIPTION];
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation removeObject:self.subscription forKey:CHANNELS];
    [installation saveInBackground];
    return true;
    

}

- (void)saveSubscription:(UIView *)view
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Saving...";
    hud.graceTime = 2.0;
    
    [[PFInstallation currentInstallation] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            hud.labelText = @"Sucess! Subscriptions saved.";
            [hud hide:YES afterDelay:0.5];
        } else {
            hud.labelText = @"Error, try again.";
            [hud hide:YES afterDelay:0.5];
        }
        [self.delegate subscriptionSaved:succeeded];
    }];

}




- (void)dealloc
{
}

@end
