//
//  WMEventSubscribeCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/17/14.
//
//

#import <UIKit/UIKit.h>
#import "UIColor+WMColors.h"
#import "WMPurpleButton.h"
#import "WMSubscription.h";

@protocol WMEventSubscribeCellDelegate <NSObject>

@optional
- (void)buttonPressed;

@end

@interface WMEventSubscribeCell : UITableViewCell

@property (strong, nonatomic) UIButton *subscribeButton;
@property (strong, nonatomic) WMSubscription *subscription;

@end
