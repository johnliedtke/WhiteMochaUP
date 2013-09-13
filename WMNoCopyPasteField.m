//
//  WMNoCopyPasteField.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/19/13.
//
//

#import "WMNoCopyPasteField.h"

@implementation WMNoCopyPasteField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
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
