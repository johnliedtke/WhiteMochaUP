//
//  WMDetailCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/16/14.
//
//

#import "WMDetailCell.h"
#import "UIColor+WMColors.h"
#import "UIFont+FlatUI.h"

@interface WMDetailCell ()
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;

@property (strong, nonatomic) IBOutlet UILabel *whenLabel;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *sponsorLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *captionLabels;


@end

@implementation WMDetailCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)awakeFromNib
{
    // Text View
    self.detailTextView.textContainer.lineFragmentPadding = 0;
    self.detailTextView.textContainerInset = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;


    
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor WMBorderColor].CGColor;
    [_detailTextView sizeToFit];
    
    for (UILabel *l in @[_whenLabel,_locationLabel,_sponsorLabel]) {
        
        [l setFont:[UIFont boldFlatFontOfSize:14.0]];
    }
    for (UILabel *l in _captionLabels) {
        [l setFont:[UIFont flatFontOfSize:14.0]];
    }
    _detailTextView.font = [UIFont flatFontOfSize:14.0];

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    //[_detailTextView sizeToFit];
    self.detailTextView.scrollEnabled = NO;
    self.detailTextView.scrollEnabled = YES;
}


- (void)setEvent:(WMEvent2 *)event
{
    _event = event;
    _locationLabel.text = _event.location;
    _detailTextView.text = _event.details;
    _whenLabel.text = [_event displayDate];
//    self.detailTextView.scrollEnabled = NO;
//    self.detailTextView.scrollEnabled = YES;

    
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

+ (id)cellView
{
WMDetailCell *customView = [[[NSBundle mainBundle] loadNibNamed:@"WMDetailCell" owner:nil options:nil] lastObject];

// make sure customView is not nil or the wrong class!
if ([customView isKindOfClass:[WMDetailCell class]])
return customView;
else
return nil;
}





@end
