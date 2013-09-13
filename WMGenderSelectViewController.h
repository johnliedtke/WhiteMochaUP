//
//  WMGenderSelectViewController.h
//  ParseStarterProject
//
//  Created by John Liedtke on 7/7/13.
//
//

#import <UIKit/UIKit.h>


@protocol GenderSelectDelegate <NSObject>


- (void)genderSelect:(NSString *)g;

@end

@interface WMGenderSelectViewController : UITableViewController

@property (nonatomic, assign) id <GenderSelectDelegate> genderDelagte;

@end
