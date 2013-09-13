//
//  WMGeneralDViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/21/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WMGeneralDescriptionViewController.h"

@protocol GeneralDetailViewDelegate <NSObject>

-(void)deleteListing:(PFObject *)furniture;

@end

@interface WMGeneralDViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate, UITextViewDelegate, WMGeneralDescriptionDelegate, UINavigationControllerDelegate>
{
    __weak IBOutlet UITextField *sellerField;
    __weak IBOutlet UITextField *dateField;
    __weak IBOutlet UITextField *priceField;
    __weak IBOutlet UITextField *locationField;
    IBOutlet UIImageView *listingImageView;
    

    __weak IBOutlet UILabel *textLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UILabel *emailLabel;
    
    UIBarButtonItem *editButton;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *deleteButton;
    UITextView *titleTextView;
    NSString *currentPrice;
    NSString *currentLocation;
    NSString *currentPhone;
    NSString *listingTitle;
    UIAlertView *deleteView;
    
}


@property (nonatomic, strong) PFObject *listing;

@property (nonatomic, strong) UIImage *listingImage;
@property (nonatomic, strong) PFObject *seller;
@property (nonatomic, unsafe_unretained) id <GeneralDetailViewDelegate> generalListingDelegate;

@end
