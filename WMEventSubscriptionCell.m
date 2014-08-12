//
//  WMEventSubscriptionCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/9/14.
//
//

#import "WMEventSubscriptionCell.h"
#import "UIFont+FlatUI.h"

@interface WMEventSubscriptionCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WMEventSubscriptionCell

- (void)setSubscription:(WMSubscription *)subscription
{
    _subscription = subscription;
    _titleLabel.text = subscription.title;
    
}

- (void)awakeFromNib
{
    _titleLabel.font = [UIFont flatFontOfSize:17.0];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
