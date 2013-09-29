//
//  WMFoodSectionViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/30/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface WMFoodSectionViewController : UITableViewController
{
    IBOutlet UILabel *commonsMonThurs;
    
    IBOutlet UILabel *comMonThuHours;
    IBOutlet UILabel *comFriday;
    IBOutlet UILabel *comFriHours;
    IBOutlet UILabel *comSaturday;
    IBOutlet UILabel *comSaturdayHours;
    
    // Cove
    IBOutlet UILabel *coveMonThurs;
    IBOutlet UILabel *coveMonThuHours;
    IBOutlet UILabel *coveFridaySaturday;
    IBOutlet UILabel *coveFriSatHours;
    IBOutlet UILabel *coveSatSun;
    IBOutlet UILabel *comSunday;
    IBOutlet UILabel *comSunHours;
    IBOutlet UILabel *coveSatSunHours;
    
    // Anchor
    IBOutlet UILabel *anchorHours;
    
    PFObject *hours;
    UIRefreshControl *refreshControl;
}

-(void)updateHours;




@end
