//
//  WMEventCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/12/13.
//
//

#import <Foundation/Foundation.h>

@interface WMEventCell : UITableViewCell
{
    
}



@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;







@end
