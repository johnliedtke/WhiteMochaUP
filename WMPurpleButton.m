//
//  WMPurpleButton.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/17/14.
//
//

#import "WMPurpleButton.h"
#import "UIColor+WMColors.h"
#import "UIFont+FlatUI.h"

@implementation WMPurpleButton

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
    //[super awakeFromNib];
    self.layer.cornerRadius = 5.0;
    self.backgroundColor = [UIColor WMPurpleColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldFlatFontOfSize:16.0];
    
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
