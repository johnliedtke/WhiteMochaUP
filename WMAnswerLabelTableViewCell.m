//
//  WMAnswerLabelTableViewCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/7/14.
//
//

#import "WMAnswerLabelTableViewCell.h"

@implementation WMAnswerLabelTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.
    self.answerLabel2.text = @"";
    self.colorIndicatorButton2.backgroundColor = [UIColor clearColor];
    self.answerLabel.text = @"";
    self.colorIndicatorButton.backgroundColor = [UIColor clearColor];
    self.answerLabel.backgroundColor = [UIColor clearColor];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.40];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
