//
//  WMRidesListViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/10/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WMRideDetailViewController.h"

@interface WMRidesListViewController : PFQueryTableViewController <UITableViewDataSource, UITableViewDelegate, WMRideDetailDelegate>
{
    
}



@end
