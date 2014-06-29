//
//  WMPollFooterView.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/1/14.
//
//

#import "WMPollFooterView.h"
#import <QuartzCore/QuartzCore.h>

@interface WMPollFooterView ()

@property (weak, nonatomic) IBOutlet UIView *whiteView;


@end

@implementation WMPollFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        //UIColor *borderColor = [[UIColor alloc] initWithRed:225.0/255.0 green:225.0/255 blue:225.0/255 alpha:1.0];
        self.whiteView.layer.borderColor = [UIColor blueColor].CGColor;
        self.whiteView.layer.borderWidth = 5.0;

    }
    return self;
}

+ (id)PollFooterView
{
    WMPollFooterView *pollFooterView = [[[NSBundle mainBundle] loadNibNamed:@"WMPollFooterView" owner:nil options:nil] lastObject];
    
    
    // make sure customView is not nil or the wrong class!
    return [pollFooterView isKindOfClass:[WMPollFooterView class]] ? pollFooterView : nil;
}
- (IBAction)thumbButtonSelected:(id)sender
{
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
