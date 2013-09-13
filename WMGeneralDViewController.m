//
//  WMGeneralDViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/21/13.
//
//

#import "WMGeneralDViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "WMGeneralDetailViewController.h"
#import "WMFurniture.h"
#import "WMDetailImageViewController.h"
#import "WMWhiteGradient.h"
#import "WMFurnitureDetailCell.h"
#import "WMDetailImgViewController.h"
#import "WMConstants.h"

@interface WMGeneralDViewController ()

@end

@implementation WMGeneralDViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set back button
    PURPLEBACK
    [self setTitle:@"Marketplace"];
    // Navigation
    [[self navigationItem] setLeftItemsSupplementBackButton:YES];
    
    // Load listing image
    // Load the image
    PFFile *imageFile = [[self listing] objectForKey:@"imageData"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        [self setListingImage:[UIImage imageWithData:data]];
        [listingImageView setUserInteractionEnabled:YES];
        [listingImageView setImage:[self listingImage]];
    }];
    
    // Get seller
    PFUser *theSeller = [[self listing] objectForKey:@"seller"];
    NSString *objectID = [theSeller objectId];
    [[PFUser query] getObjectInBackgroundWithId:objectID block:^(PFObject *object, NSError *error) {
        [self setSeller:object];
        [sellerField setText:[[self seller] objectForKey:@"fullName"]];
        [self canEdit];
        [[self tableView] reloadData];
    }];
    
    // Hide the keyboard when pressed outside text field
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    
    
    
    // ImageView
    // Attempt to center the image

    [listingImageView setContentMode:UIViewContentModeScaleAspectFit];
    CGPoint centerImageView = listingImageView.center;
    centerImageView.x = self.view.center.x;
    [listingImageView setCenter:centerImageView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listingImageViewTapped)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [listingImageView addGestureRecognizer:singleTap];
   
    
    // Other Details
    [priceField setText:[NSString stringWithFormat:@"$%@.00", [[self listing] objectForKey:@"price"]]];

    [locationField setText:[[self listing] objectForKey:@"location"]];
    
    NSDate *listdate = [[self listing] objectForKey:@"listDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, h:mm a"];
    NSString *theDate = [dateFormatter stringFromDate:listdate];
    [dateField setText:theDate];

    // Font
    NSArray *labels = [[NSArray alloc] initWithObjects:descriptionLabel, textLabel, emailLabel, nil];
    for (UILabel *label in labels) {
        [label setFont:[UIFont fontWithName:@"Museo Slab" size:16]];
    }
    
    
    
}

- (void)canEdit {
    // Edit the listing
    if ([self doesUserOwnListing]) {
        editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editListing)];
        [editButton setTintColor:PURPLECOLOR];
        [[self navigationItem] setRightBarButtonItem:editButton];
        
    }
}


- (void)editListing
{
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(doneEditing)];
    [doneButton setTintColor:PURPLECOLOR];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    
    // Delete button
    deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteListing)];
    [deleteButton setTintColor:PURPLECOLOR];
    [[self navigationItem] setLeftBarButtonItem:deleteButton];
    
    // Regex
    NSError *error = NULL;
    NSString *pricePattern = @"(?:^[$])|(?:[.]\\d\\d)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pricePattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange stringRange = NSMakeRange(0, [priceField text].length);
    NSString *numberString = [regex stringByReplacingMatchesInString:[priceField text] options:NSMatchingReportProgress range:stringRange withTemplate:@"$1"];
    [priceField setText:numberString];
    
    // Save current state
    currentLocation = [locationField text];
    listingTitle = [titleTextView text];
    currentPrice = numberString;
    
    
    [priceField setEnabled:YES];
    [locationField setEnabled:YES];
    [titleTextView setEditable:YES];
    [priceField setBorderStyle:UITextBorderStyleBezel];
    [locationField setBorderStyle:UITextBorderStyleBezel];
}

-(void)deleteListing
{
    deleteView = [[UIAlertView alloc] initWithTitle:@"Confirm Deletion" message:@"Please confirm deletion of listing." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [deleteView show];
}

- (void)doneEditing
{
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editListing)];
    [editButton setTintColor:PURPLECOLOR];
    [[self navigationItem] setRightBarButtonItem:editButton];
    [[self navigationItem] setLeftBarButtonItem:nil];
    
    // If there were changes, save
    if (![currentPrice isEqualToString:[priceField text]] || ![currentLocation isEqualToString:[locationField text]] || ![listingTitle isEqualToString:[titleTextView text]])
    {
        [[self listing] setObject:[priceField text] forKey:@"price"];
        [[self listing] setObject:[locationField text] forKey:@"location"];
        [[self listing] setObject:[titleTextView text] forKey:@"title"];
        [[self listing] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            UIAlertView *av;
            if (succeeded) {
                av = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your listing has been updated and saved!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            } else {
                av = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            }
            [av show];
        }];
    }
    
    
    [priceField setText:[NSString stringWithFormat:@"$%@.00",[priceField text]]];
    
    // Disable
    [priceField setEnabled:NO];
    [locationField setEnabled:NO];
    [titleTextView setEditable:NO];
    [priceField setBorderStyle:UITextBorderStyleNone];
    [locationField setBorderStyle:UITextBorderStyleNone];
}

- (void)updateDescription:(NSString *)updatedText
{
    [[self listing] setObject:updatedText forKey:@"itemDescription"];
    [[self listing] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved");
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [av show];
        }
    }];
}

/* If user owns listing */
- (BOOL)doesUserOwnListing
{
    return ([[[self seller] objectId] isEqualToString:[[PFUser currentUser] objectId]]);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, -2, 300, 44)];
        [titleTextView setDelegate:self];
        [titleTextView setBackgroundColor:[UIColor clearColor]];
        [titleTextView setEditable:NO];
        NSString *title = [[self listing] objectForKey:@"title"];
        [titleTextView setText:title];
        UIView *text = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [text addSubview:titleTextView];
        [titleTextView setFont:[UIFont boldSystemFontOfSize:14]];
        [titleTextView setTextAlignment:NSTextAlignmentCenter];
        [titleTextView setScrollEnabled:NO];
        [titleTextView setTextColor:[UIColor darkGrayColor]];
        return text;
        
    } else {
        return  nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [[textField text] length] + [string length] - range.length;
    if (textField == locationField) {
        return !(newLength > 35);
    } else if (textField == priceField) {
        NSCharacterSet *myCharset = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            return ([myCharset characterIsMember:c] && !(newLength > 5));
        }
    }
    return YES;
    
}




#pragma mark - Table view delegate

-(void)listingImageViewTapped
{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"WMDetailImage" bundle:nil];
        WMDetailImgViewController *meow = [story instantiateViewControllerWithIdentifier:@"WMDetailImage"];
        [meow setDetailImage:[self listingImage]];
        [meow setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:meow animated:YES completion:NULL];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0 && [indexPath row] == 1) {
        WMGeneralDescriptionViewController *descriptionView = [[WMGeneralDescriptionViewController alloc] init];
        [descriptionView setText:[[self listing] objectForKey:@"itemDescription"]];
        [descriptionView setGeneralDescriptionDelegate:self];
        [descriptionView setDoesOwn:[self doesUserOwnListing]];
        [[self navigationController] pushViewController:descriptionView animated:YES];

    } else if ([indexPath section] == 1 && [indexPath row] == 0) { // Contact seller (email)
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        [mailViewController setMailComposeDelegate:self];
        [mailViewController setSubject:[NSString stringWithFormat:@"%@", [[self listing] objectForKey:@"title"]]];
        [mailViewController setToRecipients:[NSArray arrayWithObject:[[self seller] objectForKey:@"email"]]];
        [self presentViewController:mailViewController animated:YES completion:NULL];
    } else if ([indexPath section] == 1 &&[indexPath row] == 1) {
        if ([[self listing] objectForKey:@"phone"]) {
            MFMessageComposeViewController *smsController = [[MFMessageComposeViewController alloc] init];
            [smsController setRecipients:[[NSArray alloc] initWithObjects:[[self listing] objectForKey:@"phone"], nil]];
            [smsController setMessageComposeDelegate:self];
            [self presentViewController:smsController animated:YES completion:NULL];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:@"Seller did not include a phone number." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [av show];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultSent) {
        NSLog(@"Succes, sent!");
    }
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == deleteView) {
        if (buttonIndex == 1) {
            [[self generalListingDelegate] deleteListing:[self listing]];
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  if (section == 0)
        return 44;
    else
        return 10;
}

/* Mail Delegate */
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (!error) {
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}



@end
