//
//  WMSegmentedControl.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/27/14.
//
//

#import "WMSegmentedControl.h"
#import "UIColor+WMColors.h"

@implementation WMSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tintColor = [UIColor WMDarkerPurpleColor];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
