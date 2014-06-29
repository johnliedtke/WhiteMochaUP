//
//  WMPollAnswerCellTableViewCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 5/31/14.
//
//

#import <UIKit/UIKit.h>
#import "WMCircleButton.h"

@interface WMPollAnswerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;


@property (weak, nonatomic) IBOutlet WMCircleButton *circleButton;
@property (weak, nonatomic) IBOutlet UILabel *votesLabel;

@end
