//
//  WMCommentBar.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/14/14.
//
//

#import "WMCommentBar.h"
#import "WMCommentTextViewBar.h"

@interface WMCommentBar ()
@property (strong, nonatomic) IBOutlet UIButton *postButton;


@end

@implementation WMCommentBar
NSString * const COMMENT_PLACEHOLDER = @"Add a comment...";


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.textView.textContainer.lineFragmentPadding = 0;
    self.textView.textContainerInset = UIEdgeInsetsZero;
    
    self.commentTextViewBar = [[[NSBundle mainBundle] loadNibNamed:@"WMCommentTextViewBar" owner:self options:nil] objectAtIndex:0];
    
   
    self.textView.inputAccessoryView = self.commentTextViewBar;
    _commentTextViewBar.delegate = self;
    self.textView.delegate = self;
    if ([self.textView.text isEqualToString:@""]) {
        self.textView.text = COMMENT_PLACEHOLDER;
        self.textView.textColor = [UIColor lightGrayColor]; //optional
    }
    
    
    // Border
    [self.textView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.textView.layer setBorderWidth:1.0];
    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    self.textView.textContainer.lineFragmentPadding = 0;
    self.textView.textContainerInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:.8f].CGColor;
    
    [self.layer addSublayer:bottomBorder];
    [self activatePostButton];


}

- (void)textViewBarFinishedEditing:(NSString *)text
{
    [self.textView setText:text];
    [self activatePostButton];
    if ([self.textView.text isEqualToString:@""] || [self.textView.text isEqualToString:COMMENT_PLACEHOLDER]) {
        self.textView.text = COMMENT_PLACEHOLDER;
        self.textView.textColor = [UIColor lightGrayColor]; //optional
    } else {
        [self.textView setTextColor:[UIColor blackColor]];
    }
    [self.commentTextViewBar endEditing:YES];
}

- (IBAction)textViewActivated:(id)sender
{
    [self.textView becomeFirstResponder];
}


- (void)postButtonPressed:(NSString *)comment
{
    [self activatePostButton];
    if (self.commentTextViewBar.textView.text.length > 0 && ![self.commentTextViewBar.textView.text isEqualToString:COMMENT_PLACEHOLDER]) {
        [self.commentTextViewBar.textView setText:@""];
        [self.textView setText:@""];
        [self.delegate postButtonPressed:comment];
    }
}



- (void)activatePostButton
{
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:COMMENT_PLACEHOLDER]) {
        [_postButton setEnabled:NO];
        [_postButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    } else {
        [_postButton setEnabled:YES];
        [_postButton setTitleColor:[UIColor colorWithRed:134.0/255.0 green:92.0/255.0 blue:168.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
}


- (IBAction)postButton:(id)sender
{
    [self postButtonPressed:self.commentTextViewBar.textView.text];
//    [self.delegate postButtonPressed:self.commentTextViewBar.textView.text];
}


- (void)dealloc
{
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
