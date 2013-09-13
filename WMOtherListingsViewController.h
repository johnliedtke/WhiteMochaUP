//
//  WMOtherListingsViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/2/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WMGeneralDetailViewController.h"
#import "WMGeneralDViewController.h"

@interface WMOtherListingsViewController : PFQueryTableViewController <GeneralDetailViewDelegate>
{
    
}

@property (nonatomic, strong) NSDictionary *courseInfo;


@end
