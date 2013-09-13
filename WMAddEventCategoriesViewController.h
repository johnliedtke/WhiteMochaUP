//
//  WMAddEventCategoriesViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/18/13.
//
//

#import <UIKit/UIKit.h>
#import "WMConstants.h"

@interface WMAddEventCategoriesViewController : UITableViewController <UITableViewDelegate>
{
    __weak IBOutlet UIImageView *academicImageView;
    __weak IBOutlet UILabel *academicLabel;
    __weak IBOutlet UILabel *sportsLabel;
    __weak IBOutlet UILabel *funLabel;
    __weak IBOutlet UILabel *clubsLabel;
}



@end
