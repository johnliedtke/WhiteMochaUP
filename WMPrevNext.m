//
//  WMPrevNext.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/7/13.
//
//

#import "WMPrevNext.h"

@implementation WMPrevNext
@synthesize active, fields, prevNextDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        [doneButton setTintColor:[UIColor colorWithRed:34.0/255.0 green:97.0/255.0 blue:221.0/255.0 alpha:1]];
       
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (IBAction)doneAction:(id)sender
{
    [[self prevNextDelegate] donePressed];
}

- (IBAction)nextAction:(id)sender
{
    int currentIndex = [self currentIndex];
    if (!(currentIndex == [[self fields] count]-1)) {
        [[self prevNextDelegate] prevNextPressed:[[self fields] objectAtIndex:++currentIndex]];
    }
}

- (IBAction)previousAction:(id)sender
{
    int currentIndex = [self currentIndex];    
    if (currentIndex != 0) {
        [[self prevNextDelegate] prevNextPressed:[[self fields] objectAtIndex:--currentIndex]];
    }
}

- (void)setUp:(UITextField *)textField
{
    [self setActive:textField];
    [self setCurrentIndex:[[self fields]indexOfObject:textField]];
    
    // Enable / disable
    [nextButton setEnabled:([self currentIndex] != [[self fields] count] -1)];
    [previousButton setEnabled:([self currentIndex] != 0)];
    
}
@end
