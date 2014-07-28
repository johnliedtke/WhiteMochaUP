//
//  WMFurnitureDetailVIewViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/10/13.
//
//

#import <QuartzCore/QuartzCore.h>
#import "WMGeneralDetailViewController.h"
#import "WMFurniture.h"
#import "WMDetailImageViewController.h"
#import "WMWhiteGradient.h"
#import "WMFurnitureDetailCell.h"
#import "WMDetailImgViewController.h"
#import "WMConstants.h"

@interface WMGeneralDetailViewController ()


@end

@implementation WMGeneralDetailViewController

@synthesize furniture, seller;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self setTitle:@"Marketplace"];
        
        // Apperance
        PURPLEBACK
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background stuff
    /*
    UIView *backgroundView = [[UIView alloc] init];
    UIColor *darkWhite = [[UIColor alloc] initWithRed:245 green:245 blue:245 alpha:1.0];
    [backgroundView setBackgroundColor:[UIColor grayColor]];
    [[self tableView] setBackgroundView:backgroundView];
    */
    
    // Load the special cell for details!
    [[self tableView] registerNib:[UINib nibWithNibName:@"WMFurnitureDetailCell" bundle:nil]
           forCellReuseIdentifier:@"furnitureDetailCell"];
    
    // Image
    // Load the image
    PFFile *imageFile = [furniture objectForKey:@"imageData"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        [self setFurnitureImage:[UIImage imageWithData:data]];
    }];

    
    // Get seller
    PFUser *theSeller = [furniture objectForKey:@"seller"];
    NSString *objectID = [theSeller objectId];
    
    [[PFUser query] getObjectInBackgroundWithId:objectID block:^(PFObject *object, NSError *error) {
        [self setSeller:object];
        [self canEdit];
        [[self tableView] reloadData];
    }];
    
 
    
    // Background
//    UIColor *backWhite = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"tableBack.png"]];
//    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    [background setBackgroundColor:backWhite];
//    [[self tableView] setBackgroundView:background];
    [[self tableView]setBackgroundView: nil];
    UIColor *color = [[UIColor alloc] initWithRed:229 green:229 blue:229 alpha:1.0];
    [[self tableView] setBackgroundColor:color];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];


    // Hide the keyboard when pressed outside text field
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    // Regex
    NSError *error = NULL;
    NSString *pricePattern = @"(?:^[$])|(?:[.]\\d\\d)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pricePattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange stringRange = NSMakeRange(0, [[detailCell priceField] text].length);
    NSString *numberString = [regex stringByReplacingMatchesInString:[[detailCell priceField] text] options:NSMatchingReportProgress range:stringRange withTemplate:@"$1"];
    [[detailCell priceField] setText:numberString];
    
    // Save current state
    currentLocation = [[detailCell locationField] text];
    currentPrice = numberString;
    currentPhone = [phoneField text];
    
    
    [[detailCell priceField] setEnabled:YES];
    [[detailCell locationField] setEnabled:YES];
    [[detailCell priceField] setBorderStyle:UITextBorderStyleBezel];
    [[detailCell locationField] setBorderStyle:UITextBorderStyleBezel];
}

- (void)doneEditing
{
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editListing)];
    [editButton setTintColor:PURPLECOLOR];
    [[self navigationItem] setRightBarButtonItem:editButton];
    
    // If there were changes, save
    if (![currentPrice isEqualToString:[[detailCell priceField] text]] || ![currentLocation isEqualToString:[[detailCell locationField] text]])
    {
        [furniture setObject:[[detailCell priceField] text] forKey:@"price"];
        [furniture setObject:[[detailCell locationField] text] forKey:@"location"];
        [furniture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            UIAlertView *av;
            if (succeeded) {
                av = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your listing has been updated and saved!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            } else {
                av = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            }
            [av show];
        }];
    }

    
    [[detailCell priceField] setText:[NSString stringWithFormat:@"$%@.00",[[detailCell priceField] text]]];
    
    // Disable
    [[detailCell priceField] setEnabled:NO];
    [[detailCell locationField] setEnabled:NO];
    [[detailCell priceField] setBorderStyle:UITextBorderStyleNone];
    [[detailCell locationField] setBorderStyle:UITextBorderStyleNone];
}

- (void)updateDescription:(NSString *)updatedText
{
    [furniture setObject:updatedText forKey:@"itemDescription"];
    [furniture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved");
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [av show];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* If user owns listing */
- (BOOL)doesUserOwnListing
{
    return ([[[self seller] objectId] isEqualToString:[[PFUser currentUser] objectId]]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) // Image 
        return 1;
    else if (section == 1) // Details 
        return 1;
    else if (section == 2 && [self doesUserOwnListing]) {
        return 4; // Allow owner to edit listing
    } else {
        return 3;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        return 200;
    } else if ([indexPath section] == 1) {
        return 110;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld",(long)[indexPath row]]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    UITextField *tf = nil;
   // [cell setBackgroundView:nil];
  //  [cell setBackgroundColor:[UIColor clearColor]];
    
    if ([indexPath section] == 0) { // Furniture image
        
        furnitureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 200)];
        [furnitureImageView setBackgroundColor:[UIColor clearColor]];
        
        // Attempt to center the image
        [furnitureImageView setContentMode:UIViewContentModeScaleAspectFit];
        CGPoint centerImageView = furnitureImageView.center;
        centerImageView.x = self.view.center.x;
        [furnitureImageView setCenter:centerImageView];
        [furnitureImageView setImage:[self furnitureImage]];
        [cell addSubview:furnitureImageView];
        //[cell setBackgroundView:[UIView new]];
        UIColor *color = [[UIColor alloc] initWithRed:220 green:215 blue:213 alpha:1.0];
        [furnitureImageView setBackgroundColor:color];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    } else if ([indexPath section] == 1) { // Details
       
        // Special Detail Cell
        detailCell = (WMFurnitureDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"furnitureDetailCell"];
        
        [[detailCell priceField] setText:[NSString stringWithFormat:@"$%@.00", [furniture objectForKey:@"price"]]];
        [[detailCell sellerField] setText:[seller objectForKey:@"fullName"]];
        [[detailCell locationField] setText:[furniture objectForKey:@"location"]];
        
        // Date
        NSDate *listdate = [furniture objectForKey:@"listDate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM d, h:mm a"];
        NSString *theDate = [dateFormatter stringFromDate:listdate];
        [[detailCell listedField] setText:theDate];
        
        [[detailCell priceField] setEnabled:NO];
        [[detailCell locationField] setEnabled:NO];
        [[detailCell priceField] setBorderStyle:UITextBorderStyleNone];
        [[detailCell locationField] setBorderStyle:UITextBorderStyleNone];
        [[detailCell priceField] setDelegate:self];
        [[detailCell locationField] setDelegate:self];
        
        return detailCell;
    } else if ([indexPath section] == 2 && [indexPath row] == 0) { // Description view
        [[cell textLabel] setText:@"Description"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
    } else if ([indexPath section] == 2 && [indexPath row] == 1) { // Contact
        [[cell textLabel] setText:@"Email Seller"];
        tf = emailField = [self makeTextField:[seller objectForKey:@"email"]];
        [tf setFont:[UIFont systemFontOfSize:14]];
        [emailField setFont:[UIFont systemFontOfSize:14]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        //[cell addSubview:emailField];
    } else if ([indexPath section] == 2 && [indexPath row]  == 2) { // Phone
            [[cell textLabel] setText:@"Text Seller"]; // Phone
        NSString *phoneNumber;
        if ([[furniture objectForKey:@"phone"] length] > 5) {
        //
            
           // phoneNumber = [NSString stringWithFormat:@"(%@) %@-%@", [phone substringWithRange:NSMakeRange(0, 2)],[phone substringWithRange:NSMakeRange(3, 5)], [phone substringWithRange:NSMakeRange(6, 8)]];
        } else {
            phoneNumber = @"N/A";
        }
        phoneNumber = [furniture objectForKey:@"phone"];
            tf = phoneField = [self makeTextField:phoneNumber];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [phoneField setTextAlignment:NSTextAlignmentCenter];
        [tf setFont:[UIFont systemFontOfSize:14]];
        [phoneField setFont:[UIFont systemFontOfSize:14]];
           // [cell addSubview:phoneField];
    } else if ([indexPath section] == 2 && [indexPath row] == 3) {
            [[cell textLabel] setText:@"Delete Listing"];
            [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
            [[cell textLabel] setTextColor:[UIColor redColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    if ([indexPath section] == 2) {
        [[cell textLabel] setFont:[UIFont fontWithName:@"Museo Slab" size:16]];
    }
    [tf setFrame:CGRectMake(125, 12, 170, 30)];
    [tf setBackgroundColor:[UIColor clearColor]];
    //UIColor *color = [[UIColor alloc] initWithRed:247 green:247 blue:247 alpha:1.0];
    [[cell contentView] setBackgroundColor:[UIColor redColor]];
    cell.textLabel.backgroundColor = [UIColor redColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UITextView *titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, -10, 300, 44)];
        [titleTextView setDelegate:self];
        [titleTextView setBackgroundColor:[UIColor clearColor]];
        [titleTextView setEditable:NO];
        NSString *title = [[furniture objectForKey:@"title"] uppercaseString];
        [titleTextView setText:title];
        UIView *text = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [text addSubview:titleTextView];
        [titleTextView setFont:[UIFont boldSystemFontOfSize:14]];
        [titleTextView setTextAlignment:NSTextAlignmentCenter];
        [titleTextView setScrollEnabled:NO];
        [titleTextView setUserInteractionEnabled:NO];
        return text;
        
    } else {
        return  nil;
    }
}

// Custom text field generator
- (UITextField *)makeTextField:(NSString *)text
{
    UITextField *tf = [[UITextField alloc] init];
    [tf setEnabled:NO];
    [tf setText:text];
    [tf setAdjustsFontSizeToFitWidth:YES];
    [tf setReturnKeyType:UIReturnKeyDone];
    [tf setDelegate:self];
    [tf setBackgroundColor:[UIColor redColor]];
    
    return tf;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [[textField text] length] + [string length] - range.length;
    if (textField == [detailCell locationField]) {
        return !(newLength > 25);
    } else if (textField == [detailCell priceField]) {
        NSCharacterSet *myCharset = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            return ([myCharset characterIsMember:c] && !(newLength > 5));
        }
    }
    return YES;
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Image
    if ([indexPath section] == 0 && [indexPath row] == 0) {
        /*
        WMDetailImageViewController *detailImageController = [[WMDetailImageViewController alloc] init];
        [detailImageController setDetailImage:[self furnitureImage]];
        [self presentViewController:detailImageController animated:YES completion:NULL];
         */
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"WMDetailImage" bundle:nil];
        WMDetailImgViewController *meow = [story instantiateViewControllerWithIdentifier:@"WMDetailImage"];
        [meow setDetailImage:[self furnitureImage]];
        [meow setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:meow animated:YES completion:NULL];
       // Description view
    }   else if ([indexPath section] == 2 && [indexPath row] == 0) {
        WMGeneralDescriptionViewController *descriptionView = [[WMGeneralDescriptionViewController alloc] init];
        [descriptionView setText:[furniture objectForKey:@"itemDescription"]];
        [descriptionView setGeneralDescriptionDelegate:self];
        [descriptionView setDoesOwn:[self doesUserOwnListing]];
        [[self navigationController] pushViewController:descriptionView animated:YES];
   
        // Contact seller (email)
    } else if ([indexPath section] == 2 && [indexPath row] == 1) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        [mailViewController setMailComposeDelegate:self];
        [mailViewController setSubject:[NSString stringWithFormat:@"%@", [furniture objectForKey:@"title"]]];
        [mailViewController setToRecipients:[NSArray arrayWithObject:[seller objectForKey:@"email"]]];
        [self presentViewController:mailViewController animated:YES completion:NULL];
    } else if ([indexPath section] == 2 &&[indexPath row] == 2) {
        MFMessageComposeViewController *smsController = [[MFMessageComposeViewController alloc] init];
        [smsController setRecipients:[[NSArray alloc] initWithObjects:[furniture objectForKey:@"phone"], nil]];
        [smsController setMessageComposeDelegate:self];
        [self presentViewController:smsController animated:YES completion:NULL];
    
        // Delete Listing
    } else if ([indexPath section] == 2 && [indexPath row] == 3) {
        deleteView = [[UIAlertView alloc] initWithTitle:@"Confirm Deletion" message:@"Please confirm deletion of listing." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        [deleteView show];
      
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
            [[self generalListingDelegate] deleteListing:[self furniture]];
              [[self navigationController] popViewControllerAnimated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 1.0;
    else if (section == 1)
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
