//
//  WMListFurnitureViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/7/13.
//
//

#import <UIKit/UIKit.h>
#import "WMMarketImageViewController.h"
#import "WMDescriptionViewController.h"
#import "WMTextbookCourseViewController.h"
#import "WMDescriptionDelegate.h"
#import "WMPrevNext.h"


@interface WMGeneralListingViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NewImageDelegate, WMDescriptionDelegate, WMPrevNextDelegate>
{
    UITextField *titleField;
    UITextField *priceField;
    UITextField *locationField;
    UITextField *descriptionField;
    UITextField *phoneField;
    UILabel *imageLabel;
    NSString *imageLabelText;
    UIColor *imageLabelColor;
    WMPrevNext *prevNext;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *descriptionItem;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSData *imageData;


// Used to determine which fields to add.
@property (nonatomic, retain) NSMutableDictionary *listingType;
- (void)pushDescController;


@end
