//
//  WMPlaceInfoEditViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/23/13.
//
//
#import <UIKit/UIKit.h>
@class WMPlaceItem;

@protocol WMPlaceInfoEditDelegate <NSObject>

- (void)doneEditingItem:(WMPlaceItem *)newItem;

@end

@interface WMPlaceInfoEditViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>
{
    @private
    IBOutlet UITextField *_editTextField;
    UIAlertView *_confirmationAlertView;
    UIAlertView *_errorSavingAlertView;
}

@property (nonatomic, strong) WMPlaceItem *placeItem;


// Delegate
@property (nonatomic, weak) id <WMPlaceInfoEditDelegate> delegate;

@end
