//
//  UIColor+WMColors.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/29/14.
//
//

#import "UIColor+WMColors.h"

@implementation UIColor (WMColors)

+ (UIColor *)WMPurpleColor {
    return [UIColor colorWithRed:134.0/255.0f green:92.0/255.0f blue:168.0/255.0f alpha:1.0f];
}

+ (UIColor *)WMDarkerPurpleColor {
    return [UIColor colorWithRed:82.0/255.0f green:36.0/255.0f blue:120.0/255.0f alpha:1.0f];
}

+ (UIColor *)WMPurpleColorTransparent {
    return [UIColor colorWithRed:134.0/255.0f green:92.0/255.0f blue:168.0/255.0f alpha:0.8f];
}

+ (UIColor *)WMBorderColor {
    return [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
}

+ (UIColor *)WMBackgroundColor {
    return [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];

}




@end
