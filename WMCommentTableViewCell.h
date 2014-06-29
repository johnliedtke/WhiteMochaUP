//
//  WMCommentTableViewCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/8/14.
//
//

#import <UIKit/UIKit.h>
#import "WMComment.h"

@interface WMCommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *commentImageView;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) WMComment *comment;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;

@end
