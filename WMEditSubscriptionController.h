//
//  WMEditSubscriptionController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/29/14.
//
//

#import <UIKit/UIKit.h>
#import "UIViewController+WMSaveEdit.h"
#import "WMSubscription.h"
#import "FUISwitch.h"

@interface WMEditSubscriptionController : UITableViewController <WMEditSaveDelegate,
                                                                WMSubscriptionDelegate,
                                                                FUISwitchDelegate>

@property (strong, nonatomic) WMSubscription *subscription;

@end
