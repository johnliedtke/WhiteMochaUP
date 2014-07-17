//
//  WMTextView.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/14/14.
//
//

#import "WMTextView.h"

@interface WMTextView ()

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;


@end

@implementation WMTextView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    CGSize size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, FLT_MAX)];
    
    if (!self.heightConstraint) {
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:size.height];
        [self addConstraint:self.heightConstraint];
    }
    
    self.heightConstraint.constant = size.height;
    [super updateConstraints];
}
@end
