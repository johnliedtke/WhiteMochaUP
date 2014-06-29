//
//  WMCommentTextViewBar.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/14/14.
//
//

#import <UIKit/UIKit.h>
#import "WMPoll.h"

@protocol WMCommentTextViewBarDelegate

@optional
- (void)textViewBarFinishedEditing:(NSString *)text;
- (void)postButtonPressed:(NSString *)comment;

@end

@interface WMCommentTextViewBar : UIView <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) WMPoll *poll;

@property (weak, nonatomic) id delegate;

@end
