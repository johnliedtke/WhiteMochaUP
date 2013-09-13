//
//  WMGeneralDescriptionViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/11/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol WMGeneralDescriptionDelegate <NSObject>
@optional
- (void)updateDescription:(NSString *)updatedText;


@end

@interface WMGeneralDescriptionViewController : UIViewController <UITextViewDelegate>
{
    __unsafe_unretained IBOutlet UITextView *textView;
    UIBarButtonItem *editButton;
    UIBarButtonItem *doneButton;
    NSString *editText;
}

@property (nonatomic, strong) NSString *text;
@property (nonatomic, weak) id <WMGeneralDescriptionDelegate> generalDescriptionDelegate;
@property (nonatomic) BOOL doesOwn;

@end
