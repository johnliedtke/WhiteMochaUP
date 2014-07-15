//
//  WMCommentTableViewCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/8/14.
//
//

#import "WMCommentTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface WMCommentTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *postDateLabel;
@property (strong, nonatomic) CALayer *bordertop;


@end


@implementation WMCommentTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    UIImage *image = [self squareImageWithImage:[UIImage imageNamed:@"john.png"] scaledToSize:CGSizeMake(45, 45)];
    self.commentImageView.image = image;
    self.commentImageView.layer.cornerRadius = 2.0;
    self.commentImageView.clipsToBounds = YES;
    self.commentTextView.textContainer.lineFragmentPadding = 0;
    self.commentTextView.textContainerInset = UIEdgeInsetsZero;
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

- (void)setComment:(WMComment *)comment
{
    _comment = comment;
    self.commentTextView.text = comment.comment;
    self.authorLabel.text = [_comment.user objectForKey:@"fullName"];
    self.postDateLabel.text = [WMComment postDateString:_comment.createdAt];
}

- (CGRect)commentHeight

{
    CGRect frame = _commentTextView.frame;
    CGSize sizeThatShouldFitTheContent = [_commentTextView sizeThatFits:_commentTextView.frame.size];
    frame.size.height += 20;
    frame.size = sizeThatShouldFitTheContent;
    return frame;
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

- (void)setFrame:(CGRect)frame {
    int inset = 9;
    frame.origin.x += inset;
    frame.origin.y += inset;
    frame.size.height -=  0;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:YES];
    if (highlighted) {
        UIColor *highlightColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
        [self setBackgroundColor:highlightColor];
        _bordertop.backgroundColor = highlightColor.CGColor;
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
        _bordertop.backgroundColor = [UIColor whiteColor].CGColor;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
