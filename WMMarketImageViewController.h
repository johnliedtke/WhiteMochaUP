//
//  WMMarketImageViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/8/13.
//
//

#import <UIKit/UIKit.h>

@protocol NewImageDelegate <NSObject>

- (void)newImage:(UIImage *)newImg newData:(NSData *)newData;

@end

@interface WMMarketImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIScrollViewDelegate>
{
    UIImagePickerController *imagePicker;
    __unsafe_unretained IBOutlet UIImageView *furnitureImage;
    IBOutlet UIScrollView *imageScrollView;
}
- (IBAction)takeNewPicture:(id)sender;
- (IBAction)done:(id)sender;

@property (nonatomic, unsafe_unretained) id <NewImageDelegate> updatedImageDelegate;
@property (nonatomic, strong) UIImage *updatedFurnitureImage;
@property (nonatomic, strong) NSData *updatedImageData;

@end
