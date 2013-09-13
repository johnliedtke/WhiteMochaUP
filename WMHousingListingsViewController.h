//
//  WMHousingListingsViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/5/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WMGeneralDetailViewController.h"
#import "WMGeneralDViewController.h"

@interface WMHousingListingsViewController : PFQueryTableViewController <GeneralDetailViewDelegate>


@end
