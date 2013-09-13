//
//  WMDescriptionViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/7/13.
//
//

#import <UIKit/UIKit.h>
#import "WMDescriptionDelegate.h"

@interface WMDescriptionViewController : UIViewController <UITextViewDelegate>
{
    __unsafe_unretained IBOutlet UITextView *descriptionView;
    
}

@property (nonatomic, strong) NSString *defaultText;
@property (nonatomic, unsafe_unretained) id <WMDescriptionDelegate> descriptionDelegate;



@end
