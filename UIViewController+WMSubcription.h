//
//  UIViewController+WMSubcription.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/2/14.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (WMSubcription)




@property (strong, readonly) NSString *subscription;


- (BOOL)addSubscription:(NSString *)subscription
       withNotification:(NSString *)notification;
- (BOOL)removeSubscription:(NSString *)subscription withNotification:(NSString *)notification;



+ (void)saveSubscription;



@end
