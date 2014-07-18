//
//  WMEventDetailsViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/9/14.
//
//

#import <UIKit/UIKit.h>
#import "WMRecentCommentsViewController.h"
#import "WMEvent2.h"

@interface WMEventDetailsViewController : UIViewController <WMRecentCommentsDelegate, UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) WMEvent2 *event;

@end
