//
//  WMMarketImageViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/8/13.
//
//

#import "WMMarketImageViewController.h"

@interface WMMarketImageViewController ()

@end

@implementation WMMarketImageViewController

@synthesize updatedImageData, updatedFurnitureImage, updatedImageDelegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![self updatedFurnitureImage]) {
        [self takeNewPicture:nil];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
  /*  UIImageView *newImageView = [[UIImageView alloc] initWithImage:[self updatedFurnitureImage]];
    [newImageView setFrame:CGRectMake(newImageView.frame.origin.x, newImageView.frame.origin.y, self.updatedFurnitureImage.size.height, self.updatedFurnitureImage.size.height)];
    [[self view] addSubview:newImageView];
   */
    [furnitureImage setImage:[self updatedFurnitureImage]];
    [imageScrollView setDelegate:self];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    furnitureImage = nil;
    [super viewDidUnload];
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // return which subview we want to zoom
    return furnitureImage;
}



- (IBAction)handleUploadPhotoTouch:(id)sender {
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}



- (IBAction)takeNewPicture:(id)sender
{
    // Let's create a Image Taker and take it for a walk :)
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    
    // [[self newImageDelegate] newImage:[self currentFurnitureImage]];
   // [self dismissModalViewControllerAnimated:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get orginal image
    [self setUpdatedFurnitureImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    
    // Set data
    [self setUpdatedImageData:UIImageJPEGRepresentation([self updatedFurnitureImage], 0.05f)];
    
    [furnitureImage setImage:[self updatedFurnitureImage]];
    // Take the image picker off the screen
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

- (IBAction)done:(id)sender
{
    if ([self updatedFurnitureImage]) {
        [[self updatedImageDelegate] newImage:[self updatedFurnitureImage] newData:[self updatedImageData]];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
