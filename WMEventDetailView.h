//
//  WMEventDetailView.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/16/14.
//
//

#import <UIKit/UIKit.h>
#import "WMEvent2.h"

@interface WMEventDetailView : UIView


@property (nonatomic, strong) WMEvent2 *event;

+ (id)initView;

@end
