//
//  WMEventDetailTextCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/16/14.
//
//

#import "WMEventDetailTextCell.h"

@interface WMEventDetailTextCell ()

@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) CALayer *bordertop;


@end

@implementation WMEventDetailTextCell

- (void)awakeFromNib
{
    self.detailTextView.textContainer.lineFragmentPadding = 0;
    self.detailTextView.textContainerInset = UIEdgeInsetsZero;
    //self.authorLabel.font = [UIFont boldSystemFontOfSize:14.0];
    
    
    // Border
    self.indentationWidth = 0;
    UIColor *borderColor = [[UIColor alloc] initWithRed:225.0/255.0 green:225.0/255 blue:225.0/255 alpha:1.0];
    [self.contentView.layer setBorderColor:borderColor.CGColor];
    [self.contentView.layer setBorderWidth:1.0];
    
    _bordertop = [CALayer layer];
    
    _bordertop.frame = CGRectMake(1.0f, 0, self.frame.size.width+18.0, 1.0f);
    
    _bordertop.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:_bordertop];

}

- (void)setEvent:(WMEvent2 *)event
{
    _event = event;
    // Init textview
}

- (void)setFrame:(CGRect)frame {
    int inset = 9;
    frame.origin.x += inset;
    frame.origin.y += inset;
    frame.size.height -=  0;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
