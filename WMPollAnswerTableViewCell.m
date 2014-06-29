//
//  WMPollAnswerCellTableViewCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 5/31/14.
//
//

#import "WMPollAnswerTableViewCell.h"
#import "WMCircleButton.h"

@interface WMPollAnswerTableViewCell ()

@property (nonatomic, strong) UIColor *defaultBackgroundColor;
@property (nonatomic, strong) UIColor *selectedColor;

@end

@implementation WMPollAnswerTableViewCell


- (void)awakeFromNib
{
    // Initialization code
    //self.defaultBackgroundColor = [UIColor whiteColor];
    self.selectedColor = [[UIColor alloc] initWithRed:253.0/255.0 green:253.0/255 blue:253.0/255 alpha:1.0];
    self.backgroundColor = [UIColor clearColor];
    
    self.indentationWidth = 0;
    UIColor *borderColor = [[UIColor alloc] initWithRed:225.0/255.0 green:225.0/255 blue:225.0/255 alpha:1.0];
    [self.contentView.layer setBorderColor:borderColor.CGColor];
    [self.contentView.layer setBorderWidth:1.0];
    
    // Position button label
    [self.circleButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 0.0f)];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.circleButton setHighlighted:YES];
        
        self.backgroundColor = _selectedColor;
        
    } else {
        [self.circleButton setHighlighted:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
    }


    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{

    if (highlighted) {
        [self.circleButton setHighlighted:YES];
        self.backgroundColor = _selectedColor;

    } else {
        [self.circleButton setHighlighted:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
}


- (void)setFrame:(CGRect)frame {
    int inset = 10;
    frame.origin.x += inset;
    frame.origin.y += inset;
    frame.size.height -=  5;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}

@end
