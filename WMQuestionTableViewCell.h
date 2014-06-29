//
//  WMQuestionTableViewCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/7/14.
//
//

#import <UIKit/UIKit.h>
#import "WMPoll.h"

@interface WMQuestionTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) WMPoll *poll;

@end
