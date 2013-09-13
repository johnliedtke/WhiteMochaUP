//
//  WMFurnitureDetailVIewViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/10/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WMGeneralDescriptionViewController.h"


@class WMFurnitureDetailCell;


@protocol GeneralListingDelegate <NSObject>

-(void)deleteListing:(PFObject *)furniture;

@end


@interface WMGeneralDetailViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate, UITextViewDelegate, WMGeneralDescriptionDelegate, UINavigationControllerDelegate>
{
    UIImageView *furnitureImageView;
    UITextField *priceField;
    UITextField *sellerField;
    UITextField *locationField;
    UITextField *dateField;
    UITextField *phoneField;
    UITextField *emailField;
    
    UIAlertView *deleteView;
    UIBarButtonItem *editButton;
    UIBarButtonItem *doneButton;
    NSString *currentPrice;
    NSString *currentLocation;
    NSString *currentPhone;

    WMFurnitureDetailCell *detailCell;
}

@property (nonatomic, strong) PFObject *furniture;
@property (nonatomic, strong) UIImage *furnitureImage;
@property (nonatomic, strong) PFObject *seller;
@property (nonatomic, unsafe_unretained) id <GeneralListingDelegate> generalListingDelegate;



@end
