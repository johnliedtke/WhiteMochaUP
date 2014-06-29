//
//  WMAddCommentTableViewCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/22/14.
//
//

#import "WMAddCommentTableViewCell.h"


@interface WMAddCommentTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UITextField *commentTextField;

@end

@implementation WMAddCommentTableViewCell

- (void)awakeFromNib
{
    // Border
    self.indentationWidth = 0;
    UIColor *borderColor = [[UIColor alloc] initWithRed:225.0/255.0 green:225.0/255 blue:225.0/255 alpha:1.0];
    [self.contentView.layer setBorderColor:borderColor.CGColor];
    [self.contentView.layer setBorderWidth:1.0];
    
    // Image view
    UIImage *image = [self squareImageWithImage:[UIImage imageNamed:@"john.png"] scaledToSize:CGSizeMake(35, 35)];
    self.profileImageView.image = image;
    self.profileImageView.layer.cornerRadius = 2.0;
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(1.0f, 0, self.frame.size.width+18.0, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:bottomBorder];
    
    _commentTextField.layer.borderColor = [[UIColor alloc] initWithRed:225.0/255.0 green:225.0/255.0  blue:225.0/255.0  alpha:1.0].CGColor;
    _commentTextField.layer.borderWidth = 1.0;
    _commentTextField.layer.cornerRadius = 5.0;
    _commentTextField.backgroundColor = [[UIColor alloc] initWithRed:252.0/255.0 green:252.0/255.0 blue:252.0/255.0 alpha:1.0];
    
}

- (void)setFrame:(CGRect)frame {
    int inset = 9;
    frame.origin.x += inset;
    frame.origin.y += inset;
    frame.size.height -=  0;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}


- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
