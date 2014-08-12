//
//  WMSubscription.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/30/14.
//
//

#import <Foundation/Foundation.h>

#define STANDARD_SUBSCRIPTION @"standard"
#define PUSH_NOTIFICATIONS_SUBSCRIPTION @"push_notifications"
#define TWENTY_FOUR_HOUR_SUBSCRIPTION @"twenty_four_hour"
#define ONE_HOUR_SUBSCRIPTION @"one_hour"
#define THIRTY_MINUTE_SUBSCRIPTION @"thirty_minute"

@protocol WMSubscriptionDelegate <NSObject>

@optional
- (void)subscriptionSaved:(BOOL)success;

@end

@interface WMSubscription : NSObject
@property (strong, readonly) NSString *subscription;
@property (strong, readonly) NSString *title;
@property (nonatomic, weak) id <WMSubscriptionDelegate> delegate;

- (instancetype)initWithSubscription:(NSString *)subscription;

- (BOOL)addSubscription:(NSString *)subscription
       withNotification:(NSString *)notification;
- (BOOL)removeSubscription:(NSString *)subscription withNotification:(NSString *)notification;

- (BOOL)deleteSubscription;

- (BOOL)updateSubscriptionNotification:(NSString *)notification remove:(BOOL)remove;

- (BOOL)isSubscribedToNotification:(NSString *)notification;
- (void)saveSubscription:(UIView *)view;

+ (BOOL)isSubscribedToSubscription:(NSString *)subscription;

+ (NSArray *)subscriptions; // WMSubscriptions
+ (NSArray *)subscriptionStrings; // NSString

@end
