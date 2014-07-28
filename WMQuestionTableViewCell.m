//
//  WMQuestionTableViewCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/7/14.
//
//

#import "WMQuestionTableViewCell.h"
#import "WMPoll.h"

@interface WMQuestionTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *pollNumberLabel;


@end

@implementation WMQuestionTableViewCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)setPoll:(WMPoll *)poll
{
    _poll = poll;
    _questionLabel.text = _poll.question;
    _dateLabel.text = [WMPoll pollDate];
    _pollNumberLabel.text = [NSString stringWithFormat:@"Poll of the day #%lu",(unsigned long)_poll.pollNumber];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
