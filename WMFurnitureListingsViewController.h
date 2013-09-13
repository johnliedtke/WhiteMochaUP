//
//  WMFurnitureListingsViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/9/13.
//
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "WMGeneralDetailViewController.h"
#import "WMGeneralDViewController.h"

@interface WMFurnitureListingsViewController : PFQueryTableViewController <UITableViewDelegate, GeneralListingDelegate, GeneralDetailViewDelegate>

@end
