//
//  WMListingCategoryViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/29/13.
//
//

#import <UIKit/UIKit.h>

@interface WMListingCategoryViewController : UITableViewController
{
    NSArray *categories;
    NSArray *sales;
    NSArray *services;
    IBOutlet UILabel *furnitureLabel;
    IBOutlet UILabel *textbookLabel;
    IBOutlet UILabel *otherLabel;
    IBOutlet UILabel *housingLabel;
    IBOutlet UILabel *ridesLabel;
    
    
}


@end
