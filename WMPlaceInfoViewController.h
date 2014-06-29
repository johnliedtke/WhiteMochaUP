//
//  WMPlaceInfoViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/22/13.
//
//

#import <UIKit/UIKit.h>
#import "WMPlaceInfoEditViewController.h"
@class WMPlaceInfo, WMWebViewController;

@interface WMPlaceInfoViewController : UITableViewController <WMPlaceInfoEditDelegate, UITableViewDelegate>
{
    bool _doneLoading;
    bool _canEdit;
    
    // Edit buttons
    UIBarButtonItem *_editButton;
    UIBarButtonItem *_doneButton;
    
}


@property (nonatomic) NSIndexPath *upadteIndex;

// The info for the view
@property (nonatomic, strong) WMPlaceInfo *placeInfo;

// Webview
@property (nonatomic, strong) WMWebViewController *webViewController;


@end
