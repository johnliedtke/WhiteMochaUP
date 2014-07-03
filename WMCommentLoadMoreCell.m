//
//  WMCommentLoadMoreCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/2/14.
//
//

#import "WMCommentLoadMoreCell.h"

@interface WMCommentLoadMoreCell ()

@property (strong, nonatomic) IBOutlet UIView *visibleVIew;


@end

@implementation WMCommentLoadMoreCell

- (void)awakeFromNib
{
    // Initialization code
    // Border
    self.indentationWidth = 0;
    UIColor *borderColor = [[UIColor alloc] initWithRed:225.0/255.0 green:225.0/255 blue:225.0/255 alpha:1.0];
    [_visibleVIew.layer setBorderColor:borderColor.CGColor];
    [_visibleVIew.layer setBorderWidth:1.0];
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(1.0f, 0, self.frame.size.width+18.0, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:bottomBorder];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //[_visibleVIew setBackgroundColor:[UIColor lightTextColor]];

}



- (void)setFrame:(CGRect)frame {
    int inset = 9;
    frame.origin.x += inset;
    frame.origin.y += inset;
    frame.size.height -=  0;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}


@end
