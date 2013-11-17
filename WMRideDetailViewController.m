//
//  WMRideDetailViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/11/13.
//
//

#import "WMRideDetailViewController.h"
#import "WMGeneralDescriptionViewController.h"
#import "WMConstants.h"

@interface WMRideDetailViewController ()

@end

@implementation WMRideDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Font
    [rideDetailsLabel setFont:[UIFont fontWithName:@"Museo Slab" size:16]];
    [self setTitle:@"Ride"];
    
    // Set Fields
    [toField setText:[[self ride] objectForKey:@"to"]];
    [fromField setText:[[self ride] objectForKey:@"from"]];
    
    // Date
    NSDate *departDate = [[self ride] objectForKey:@"departureDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, h:mm a"];
    NSString *theDate = [dateFormatter stringFromDate:departDate];
    [departureField setText:theDate];
    
    // Fee
    [feeField setText:[[self ride] objectForKey:@"fee"]];
    
    // Fetch driver information
    PFUser *driver = [[self ride] objectForKey:@"rider"];
    NSString *objectID = [driver objectId];
    [[PFUser query] getObjectInBackgroundWithId:objectID block:^(PFObject *object, NSError *error) {
        [self setDriver:object];
        [driverField setText:[self.driver objectForKey:@"fullName"]];
        // Edit the listing
        if ([self doesUserOwnListing]) {
            editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editListing)];
            [[self navigationItem] setRightBarButtonItem:editButton];
        }
        [[self tableView] reloadData];
    }];
    
    
    
    // DisAble Field
    editFields = [[NSArray alloc] initWithObjects:toField, fromField, departureField, nil];

    // Labels
    [emaiLabel setFont:[UIFont fontWithName:@"Museo Slab" size:16]];
    [textLabel setFont:[UIFont fontWithName:@"Museo Slab" size:16]];
    
    

 
    
  
    
    // Keyboard PREV NEXT
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"WMPrevNext" owner:self options:nil];
    prevNext = [subviewArray objectAtIndex:0];
    [prevNext setPrevNextDelegate:self];
    NSMutableArray *mutableEdit = [[NSMutableArray alloc] initWithArray:editFields];
    [prevNext setFields:mutableEdit];
    for (UITextField *tf in editFields) {
        [tf setInputAccessoryView:prevNext];
        [tf setEnabled:NO];
    }
    
    // Title
    [self setTitle:@"Rides"];
    
    // Hide the keyboard when pressed outside text field
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(donePressed)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setDate:[[self ride] objectForKey:@"departureDate"]];
    [departureField setInputView:datePicker];
    
    // Navigation
    [[self navigationItem] setLeftItemsSupplementBackButton:YES];

}

#pragma mark - Edit Listing

- (void)editListing
{
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    editButton = nil;
    deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteRide)];
    [[self navigationItem] setLeftBarButtonItem:deleteButton];
    
    for (UITextField *tf in editFields) {
        [tf setEnabled:YES];
        [tf setBorderStyle:UITextBorderStyleLine];
    }
    
    // Save the current state
    to = [toField text];
    from = [fromField text];
    departure = [[self ride] objectForKey:@"departureDate"];
    fee = [feeField text];
}

- (void)deleteRide
{
    [[self delegate] deleteRide:[self ride]];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)doneEditing
{
    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editListing)];
    [[self navigationItem] setRightBarButtonItem:editButton];
    doneButton = nil;
    deleteButton = nil;
    
    [[self navigationItem] setLeftBarButtonItem:nil];
    
    // Disable again
    for (UITextField *tf in editFields) {
        [tf setEnabled:NO];
        [tf setBorderStyle:UITextBorderStyleNone];
    }
    
    // Only save if there were changes
    if (![to isEqualToString:[toField text]] || ![from isEqualToString:[fromField text]] || departure != [datePicker date] || ![fee isEqualToString:[feeField text]]) {
        [[self ride] setObject:[toField text] forKey:@"to"];
        [[self ride] setObject:[fromField text] forKey:@"from"];
        [[self ride] setObject:[datePicker date] forKey:@"departureDate"];
        [[self ride] setObject:[feeField text] forKey:@"fee"];
        [[self ride] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Saved");
            } else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error :(" message:[error description] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [av show];
            }
        }];
    }

}

- (void)updateDescription:(NSString *)updatedText
{
    [[self ride] setObject:updatedText forKey:@"otherInfo"];
    [[self ride] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved");
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error :(" message:[error description] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [av show];
        }
    }];
}



#pragma mark - UITextField Shit
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [[textField text] length] + [string length] - range.length;
    if (textField == toField || textField == fromField) {
        return !(newLength > 30);
    } else if (textField == feeField) {
        return !(newLength > 25);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [prevNext setUp:textField];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath section] == 0 && [indexPath row] == [prevNext currentIndex]-1) {
        //[[[cell subviews] objectAtIndex:0] becomeFirstResponder];
        NSLog(@"meow");
    }
}
- (void)donePressed
{
    [self.view endEditing:YES];
}

-(void)prevNextPressed:(UITextField *)textField
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:[prevNext currentIndex] inSection:0];
    [[self tableView] scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [textField becomeFirstResponder];
}


- (void)datePickerValueChanged
{
    NSDate *departDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, h:mm a"];
    NSString *theDate = [dateFormatter stringFromDate:departDate];
    [departureField setText:theDate];
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0 && [indexPath row] == 2) {
        WMGeneralDescriptionViewController *descriptionView = [[WMGeneralDescriptionViewController alloc] init];
        [descriptionView setText:[[self ride] objectForKey:@"otherInfo"]];
        [descriptionView setDoesOwn:[self doesUserOwnListing]];
        [descriptionView setGeneralDescriptionDelegate:self];
        [[self navigationController] pushViewController:descriptionView animated:YES];
    } else if (([indexPath section] == 1 && [indexPath row] == 0)) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        [mailViewController setMailComposeDelegate:self];
        [mailViewController setSubject:[NSString stringWithFormat:@"RIDE TO: %@ FROM: %@", [[self ride] objectForKey:@"to"], [[self ride] objectForKey:@"from"]]];
        [mailViewController setToRecipients:[NSArray arrayWithObject:[[self driver] objectForKey:@"email"]]];
        [self presentViewController:mailViewController animated:YES completion:NULL];
    } else if ([indexPath section] == 1 && [indexPath row] == 1) {
        if ([[self ride] objectForKey:@"phone"]) {
            MFMessageComposeViewController *smsController = [[MFMessageComposeViewController alloc] init];
            [smsController setRecipients:[[NSArray alloc] initWithObjects:[[self ride] objectForKey:@"phone"], nil]];
            [smsController setMessageComposeDelegate:self];
            [self presentViewController:smsController animated:YES completion:NULL];
        } else  {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:@"Seller did not include a phone number." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [av show];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/* Mail Delegate */
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (!error) {
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* If user owns listing */
- (BOOL)doesUserOwnListing
{
    return ([[[self driver] objectId] isEqualToString:[[PFUser currentUser] objectId]]);
}

@end
