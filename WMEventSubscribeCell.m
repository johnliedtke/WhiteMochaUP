//
//  WMEventSubscribeCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/17/14.
//
//

#import "WMEventSubscribeCell.h"
#import "UIFont+FlatUI.h"
#import "UIButton+WMButton.h"

@implementation WMEventSubscribeCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor WMBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _subscribeButton.titleLabel.font = [UIFont flatFontOfSize:15.0];
    _subscribeButton = [UIButton purpleButtonWithFrame:CGRectMake(10, 20, 300, 40)];
    [_subscribeButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_subscribeButton];
    
}

- (void)setSubscription:(WMSubscription *)subscription
{
    _subscription = subscription;
    [self setSubscriptionButtonText];
}

- (void)setSubscriptionButtonText
{
    if ([WMSubscription isSubscribedToSubscription:self.subscription.subscription]) {
        [_subscribeButton setTitle:[NSString stringWithFormat:@"Unsubscribe to %@",self.subscription.title] forState:UIControlStateNormal];
    } else {
        [_subscribeButton setTitle:[NSString stringWithFormat:@"Subscribe to %@", self.subscription.title] forState:UIControlStateNormal];
    }
}

- (void)buttonPressed:(id)sender;
{
    if ([WMSubscription isSubscribedToSubscription:self.subscription.subscription]) {
        [self.subscription deleteSubscription];
    } else {
        [self.subscription addSubscription:self.subscription.subscription withNotification:STANDARD_SUBSCRIPTION];
    }
    [self setSubscriptionButtonText];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
