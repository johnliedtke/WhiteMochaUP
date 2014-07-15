//
//  WMRecentCommentsViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/12/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface WMRecentCommentsViewController : UITableViewController


@property (nonatomic, strong) PFObject *parent;

@end
