//
//  WMTextbookListingsViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/2/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WMGeneralDViewController.h"

@interface WMTextbookListingsViewController : PFQueryTableViewController <GeneralDetailViewDelegate>
{
    
}


@property (nonatomic, strong) NSDictionary *courseInfo;
@end
