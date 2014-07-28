//
//  WMContainerViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/26/14.
//
//

#import <UIKit/UIKit.h>
#define MAIN_EVENTS_SEGUE @"eventsMainSegue"
#define SUBSCRIPTION_EVENTS_SEGUE @"eventsSubscriptionSegue"
#define FUN_EVENTS_SEGUE @"eventsFunUserSegue"

@interface WMContainerViewController : UIViewController

- (void)swapViewControllers:(NSString *)segue;

@property (nonatomic, readonly) NSString *currentSegue;
@property (strong, nonatomic, readonly) NSString *currentSegueIdentifier;


@end
