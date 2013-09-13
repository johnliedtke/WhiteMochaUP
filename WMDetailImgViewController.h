//
//  WMDetailImgViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/12/13.
//
//

#import <UIKit/UIKit.h>

@interface WMDetailImgViewController : UIViewController <UIScrollViewDelegate>
{
    __weak IBOutlet UIButton *backButton;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *detailImage;
- (IBAction)goback:(id)sender;

@end
