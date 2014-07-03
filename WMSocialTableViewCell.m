//
//  WMSocialTableViewCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/6/14.
//
//

#import "WMSocialTableViewCell.h"

@interface WMSocialTableViewCell ()

@property (strong, nonatomic) IBOutlet UITextView *lastVotedTextView;


@end

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

- (void)setLastVotedLabel
{
//    if (_poll.votes == 0) {
//        NSString *noVoted = @"You're the first to vote";
//        _lastVotedTextView.text = noVoted;
//    } else {
//        NSMutableAttributedString *voted = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ last voted.", [_poll]]
//        
//    }
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
