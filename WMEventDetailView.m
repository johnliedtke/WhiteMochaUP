//
//  WMEventDetailView.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/16/14.
//
//

#import "WMEventDetailView.h"
#import "UIColor+WMColors.h"

@interface WMEventDetailView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;


@end

@implementation WMEventDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)initView
{
    WMEventDetailView *eventDetailView = [[[NSBundle mainBundle] loadNibNamed:@"WMEventDetailView" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([eventDetailView isKindOfClass:[WMEventDetailView class]])
        return eventDetailView;
    else
        return nil;
}

- (void)setEvent:(WMEvent2 *)event
{
    _event = event;
    
}



- (void)awakeFromNib
{
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.borderColor = [UIColor WMBorderColor].CGColor;
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
