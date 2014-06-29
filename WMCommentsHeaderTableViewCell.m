//
//  WMCommentsHeaderTableViewCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/12/14.
//
//

#import "WMCommentsHeaderTableViewCell.h"


@interface WMCommentsHeaderTableViewCell ()



@end

@implementation WMCommentsHeaderTableViewCell

- (void)awakeFromNib
{
    // Border
    self.indentationWidth = 0;
    UIColor *borderColor = [[UIColor alloc] initWithRed:225.0/255.0 green:225.0/255 blue:225.0/255 alpha:1.0];
    [self.contentView.layer setBorderColor:borderColor.CGColor];
    [self.contentView.layer setBorderWidth:1.0];
}

- (void)setFrame:(CGRect)frame {
    int inset = 9;
    frame.origin.x += inset;
    frame.origin.y += inset;
    frame.size.height -=  0;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}



- (IBAction)postCommentPressed:(id)sender
{
    [self.delegate viewAllPressed];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
