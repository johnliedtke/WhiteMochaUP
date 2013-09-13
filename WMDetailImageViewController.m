//
//  WMDetailImageViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/21/13.
//
//

#import "WMDetailImageViewController.h"

@interface WMDetailImageViewController ()

@end

@implementation WMDetailImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    // The Image
    
    [detailImageView setImage:[self detailImage]];
    
//    [detailImageView setContentMode:UIViewContentModeScaleAspectFit];
//    CGPoint centerImageView = detailImageView.center;
//    centerImageView.x = self.view.center.x;
//    [detailImageView setCenter:centerImageView];
    

    
    detailImageView.frame = scrollView.bounds;
    [detailImageView setContentMode:UIViewContentModeScaleAspectFit];
    scrollView.contentSize = [[self detailImage] size];
    scrollView.maximumZoomScale = 4.0;
    scrollView.minimumZoomScale = 1.0;
    scrollView.delegate = self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return detailImageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    detailImageView = nil;
    backButton = nil;
    [super viewDidUnload];
}
- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
