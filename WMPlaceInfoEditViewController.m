//
//  WMPlaceInfoEditViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/23/13.
//
//

#import "WMPlaceInfoEditViewController.h"
#import <Parse/Parse.h>
#import "WMPlaceItem.h"

@interface WMPlaceInfoEditViewController ()

@end

@implementation WMPlaceInfoEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the title
    NSString *title = [[NSString alloc] initWithFormat:@"Edit %@", [[self placeItem] itemTitle]];
    [[self navigationItem] setTitle:title];
    
    // Make the text field pop up
    [_editTextField becomeFirstResponder];
    [_editTextField setDelegate:self];
    
    // Set the edit field text
    [_editTextField setText:[[self placeItem] itemContents]];
    
    // Add the cancel button
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing)];
    [[self navigationItem] setLeftBarButtonItem:cancelButton];
    
    // Add the done button
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    
    // Adjust the keyboard
    if ([[[self placeItem] itemContents] rangeOfString:@"phone" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        [_editTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    }
    [_editTextField setReturnKeyType:UIReturnKeyDone];
}

#pragma mark Editing

// Cancel editing, return to previous screen
- (void)cancelEditing
{
    [[self delegate] doneEditingItem:nil];
}

// Done editing
// Display an alertview to check
- (void)doneEditing
{
    // Check to make sure they want to commit the changes
    _confirmationAlertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure these changes are correct?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [_confirmationAlertView show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doneEditing];
    return YES;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == _confirmationAlertView) {
        if (buttonIndex == 0) {
            return;
        } else {
            // Do some checks on the input

            // Update the object
            [[self placeItem] setItemContents:[_editTextField text]];
            
            // Save to parse
            [[self placeItem] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // return
                    [[self delegate] doneEditingItem:[self placeItem]];
                } else {
                    // Display the error to the user
                    _errorSavingAlertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                    [_errorSavingAlertView show];
                }
            }];
            
            // Return
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
