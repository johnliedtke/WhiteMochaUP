//
//  WMPrevNext.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/7/13.
//
//

#import <UIKit/UIKit.h>

@protocol WMPrevNextDelegate <NSObject>

- (void)donePressed;
- (void)prevNextPressed:(UITextField *)textField;

@end

@interface WMPrevNext : UIToolbar
{
    __unsafe_unretained IBOutlet UIBarButtonItem *previousButton;
    __weak IBOutlet UIBarButtonItem *doneButton;

    __unsafe_unretained IBOutlet UIBarButtonItem *nextButton;
}

- (IBAction)doneAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)previousAction:(id)sender;
@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, strong) UITextField *active;
@property (nonatomic, unsafe_unretained) UIViewController *vc;
@property (nonatomic, unsafe_unretained) id <WMPrevNextDelegate> prevNextDelegate;
@property (nonatomic) int currentIndex;

- (void)setUp:(UITextField *)textField;


@end
