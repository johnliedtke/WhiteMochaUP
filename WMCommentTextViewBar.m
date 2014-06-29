//
//  WMCommentTextViewBar.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/14/14.
//
//

#import "WMCommentTextViewBar.h"
#import <QuartzCore/QuartzCore.h>
#import "WMCommentBar.h"

@interface WMCommentTextViewBar ()


@property (strong, nonatomic) IBOutlet UIButton *postButton;

@end

@implementation WMCommentTextViewBar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.textView.textContainer.lineFragmentPadding = 0;
    self.textView.textContainerInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    // Border
    [self.textView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.textView.layer setBorderWidth:1.0];
    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    
    //UIColor *borderColor = [[UIColor alloc] initWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]
    
    
    CGSize sizeThatShouldFitTheContent = [self.textView sizeThatFits:self.textView.frame.size];
    CGRect savedFrame = self.frame;
    savedFrame.size = sizeThatShouldFitTheContent;
    //self.frame = savedFrame;
    
    self.textView.delegate = self;
    
    
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:.8f].CGColor;
    
    [self.layer addSublayer:bottomBorder];
    [self updateUI];
    
}

const static int MAX_HEIGHT = 100;
-(void)textViewDidChange:(UITextView *)textView
{
    [self updateUI];
}

- (void)updateUI
{
    CGSize sizeThatShouldFitTheContent = [self.textView sizeThatFits:self.textView.frame.size];
    CGRect savedFrame = self.frame;
    savedFrame.size = sizeThatShouldFitTheContent;
    savedFrame.size.width = 320;
    savedFrame.size.height +=13;
    if (savedFrame.size.height > MAX_HEIGHT) savedFrame.size.height = MAX_HEIGHT;
    self.frame = savedFrame;
    [self activatePostButton];
    [self setNeedsDisplay];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:COMMENT_PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [self updateUI];
    [self.textView becomeFirstResponder];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = COMMENT_PLACEHOLDER;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [self.textView resignFirstResponder];
    [self.delegate textViewBarFinishedEditing:self.textView.text];
}

- (IBAction)postButtonPressed:(id)sender
{
    if (self.textView.text.length > 0) {
        [self.delegate postButtonPressed:self.textView.text];
        [self.textView setText:@""];
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



- (void)hideKeyBoard
{
    NSLog(@"trying to hide keybardr");
    [self.textView resignFirstResponder];
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
