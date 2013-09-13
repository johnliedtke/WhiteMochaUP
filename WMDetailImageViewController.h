//
//  WMDetailImageViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/21/13.
//
//

#import <UIKit/UIKit.h>

@interface WMDetailImageViewController : UIViewController <UIScrollViewDelegate>
{
    
    __weak IBOutlet UIScrollView *scrollView;
    __unsafe_unretained IBOutlet UIButton *backButton;
    __unsafe_unretained IBOutlet UIImageView *detailImageView;
}
    


@property (nonatomic, strong) UIImage *detailImage;
- (IBAction)goBack:(id)sender;

@end
