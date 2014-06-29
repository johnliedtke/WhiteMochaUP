//
//  WMCircleButton.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/1/14.
//
//

#import <UIKit/UIKit.h>

@interface WMCircleButton : UIButton

- (void)drawCircleButton:(UIColor *)color title:(NSString *)title;

@property (nonatomic, readonly) UIColor *color;

@end
