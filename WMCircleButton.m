//
//  WMCircleButton.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/1/14.
//
//

#import "WMCircleButton.h"
#import <QuartzCore/QuartzCore.h>

@interface WMCircleButton ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, readwrite) UIColor *color;

@end

@implementation WMCircleButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawCircleButton:(UIColor *)color title:(NSString *)title
{
    self.color = color;
    [self setTitle:title forState:UIControlStateNormal];
    
    [self setTitleColor:color forState:UIControlStateNormal];
    
    self.circleLayer = [CAShapeLayer layer];
    
    [self.circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self bounds].size.width,
                                           [self bounds].size.height)];
    [self.circleLayer setPosition:CGPointMake(CGRectGetMidX([self bounds]),CGRectGetMidY([self bounds]))];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    
    [self.circleLayer setPath:[path CGPath]];
    
    [self.circleLayer setStrokeColor:[color CGColor]];
    
    [self.circleLayer setLineWidth:1.5f];
    [self.circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    [self.layer insertSublayer:self.circleLayer atIndex:0];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted)
    {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        self.titleLabel.textColor = [UIColor whiteColor];

        //self.title.textColor = [UIColor whiteColor];
        [self.circleLayer setFillColor:self.color.CGColor];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.circleLayer setFillColor:[UIColor clearColor].CGColor];
        [self setTitleColor:self.color forState:UIControlStateNormal];
       // [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
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
