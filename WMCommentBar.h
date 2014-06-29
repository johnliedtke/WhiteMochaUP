//
//  WMCommentBar.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/14/14.
//
//

#import <UIKit/UIKit.h>
#import "WMCommentTextViewBar.h"

@protocol WMCommentBarDelegate

@optional
- (void)hideButtonPressed;
- (void)postButtonPressed:(NSString *)comment;

@end


@interface WMCommentBar : UIView <WMCommentTextViewBarDelegate,UITextViewDelegate>
extern NSString * const COMMENT_PLACEHOLDER;

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, weak) WMCommentTextViewBar *commentTextViewBar;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) id  <WMCommentBarDelegate> delegate;



@end
