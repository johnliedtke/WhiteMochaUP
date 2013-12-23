//
//  WMPlaceInfoViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/22/13.
//
//

#import <UIKit/UIKit.h>
#import "WMPlaceInfoEditViewController.h"
@class WMPlaceInfo;

@interface WMPlaceInfoViewController : UITableViewController <WMPlaceInfoEditDelegate>
{
    bool _doneLoading;
}

// The info for the view
@property (nonatomic, strong) WMPlaceInfo *placeInfo;

@end
