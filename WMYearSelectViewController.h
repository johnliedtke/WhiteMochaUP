//
//  WMYearSelectViewController.h
//  ParseStarterProject
//
//  Created by John Liedtke on 7/7/13.
//
//

#import <UIKit/UIKit.h>

@protocol YearSelectDelegate <NSObject>


- (void)yearSelect:(NSString *)year yearNumber:(int)number;

@end

@interface WMYearSelectViewController : UITableViewController

@property (nonatomic, assign) id <YearSelectDelegate> yearDelagte;

@end
