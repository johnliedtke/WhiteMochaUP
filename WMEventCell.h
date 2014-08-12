//
//  WMEventCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/12/13.
//
//

#import <Foundation/Foundation.h>
#import "WMEvent2.h"

@interface WMEventCell : UITableViewCell
{
    
}

@property (nonatomic, strong) WMEvent2 *event;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;







@end
