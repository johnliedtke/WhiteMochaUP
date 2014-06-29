//
//  WMSocialTableViewCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/6/14.
//
//

#import "WMSocialTableViewCell.h"

@implementation WMSocialTableViewCell

- (void)awakeFromNib
{
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    int inset = 10;
    frame.origin.x += 0;
    frame.origin.y += inset;
    frame.size.height -=  5;
    frame.size.width -= 2 * 0;
    [super setFrame:frame];
}


@end
