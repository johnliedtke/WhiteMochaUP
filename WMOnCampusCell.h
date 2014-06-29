//
//  WMOnCampusCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 1/5/14.
//
//

#import <UIKit/UIKit.h>

@interface WMOnCampusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *displayTitle;
@property (weak, nonatomic) IBOutlet UILabel *hours;
@property (weak, nonatomic) IBOutlet UIImageView *displayImage;

@end
