//
//  WMCommentsHeaderTableViewCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/12/14.
//
//

#import <UIKit/UIKit.h>
@protocol WMCommentsHeaderDelegate

@optional
- (void)viewAllPressed;

@end


@interface WMCommentsHeaderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) id delegate;

@end
