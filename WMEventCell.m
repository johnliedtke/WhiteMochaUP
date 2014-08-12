//
//  WMEventCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/12/13.
//
//

#import "WMEventCell.h"
#import "UIFont+FlatUI.h"
#import "UIColor+FlatUI.h"

@implementation WMEventCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    _titleLabel.font = [UIFont flatFontOfSize:16.0];
    _locationLabel.font = [UIFont flatFontOfSize:12.0];

}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setEvent:(WMEvent2 *)event
{
    _event = event;
    _titleLabel.text = event.title;
    _locationLabel.text = event.location;
    _timeLabel.text = [self createHourString:event.start];
    _periodLabel.text = [self createPeriodString:event.start];
    UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_event.subCategory]];
    if (!icon) {
        icon = [UIImage imageNamed:@"soccer.png"];
    }
    UIImage *scaledImage = [WMEventCell imageWithImage:icon scaledToSize:CGSizeMake(20, 20)];
    self.icon.image = icon;
}


- (NSString *)createHourString:(NSDate *)date;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"h:mm"];
    return [dateFormatter stringFromDate:date];
}

- (NSString *)createPeriodString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"a"];
    return [dateFormatter stringFromDate:date];
}

@end
