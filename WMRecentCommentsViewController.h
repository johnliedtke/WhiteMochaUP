//
//  WMRecentCommentsViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/12/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol WMRecentCommentsDelegate <NSObject>

@optional
- (void)loadedComments:(CGRect)tableViewFrame;

@end

@interface WMRecentCommentsViewController : UITableViewController


@property (nonatomic, strong) PFObject *parent;

@property (nonatomic, weak) id <WMRecentCommentsDelegate> delegate;

@end
