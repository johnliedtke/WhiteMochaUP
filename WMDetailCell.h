//
//  WMDetailCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/16/14.
//
//

#import <UIKit/UIKit.h>
#import "WMEvent2.h"

@interface WMDetailCell : UITableViewCell


@property (nonatomic, strong) WMEvent2 *event;





+ (id)cellView;

@end
