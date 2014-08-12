//
//  UIButton+WMButton.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/10/14.
//
//

#import "UIButton+WMButton.h"
#import "UIColor+WMColors.h"
#import "UIFont+FlatUI.h"
#import "UIImage+WMImage.h"


@implementation UIButton (WMButton)



+ (UIButton *)purpleButtonWithFrame:(CGRect)frame
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    button.layer.cornerRadius = 5.0;
    button.backgroundColor = [UIColor WMPurpleColor];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16.0];
    button.clipsToBounds = YES;
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16.0];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    [button setBackgroundImage:[UIImage imageWithColor:[UIColor WMPurpleColor]]
//                      forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageWithColor:[UIColor WMDarkerPurpleColor]] forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor WMPurpleColor];
    
    return button;
}



@end
