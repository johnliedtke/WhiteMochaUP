//
//  WMEventSubscribeCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/17/14.
//
//

#import "WMEventSubscribeCell.h"
#import "UIColor+WMColors.h"

@implementation WMEventSubscribeCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor WMBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
