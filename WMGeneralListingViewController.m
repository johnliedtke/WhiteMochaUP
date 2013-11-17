//
//  WMListFurnitureViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/7/13.
//
//

#import "WMGeneralListingViewController.h"
#import "WMFurniture.h"
#import "WMTextbookDescViewController.h"
#import "WMGeneralListing.h"
#import "WMPrevNext.h"
#import "WMConstants.h"

@interface WMGeneralListingViewController ()

@end

@implementation WMGeneralListingViewController

@synthesize descriptionItem, price, title, location, phone;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        UINavigationItem *titles = [self navigationItem];
        [titles setTitle:@"Listing"];
        [[self tableView] setDelegate:self];
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

    // Hide the keyboard when pressed outside text field
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissList)];
    [cancelButton setTintColor:PURPLECOLOR];
    [[self navigationItem] setRightBarButtonItem:cancelButton];
    
    imageLabelText = @"Take Picture";
    imageLabelColor = [UIColor blackColor];
    
    // Init keyboard crap
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"WMPrevNext" owner:self options:nil];
    prevNext = [subviewArray objectAtIndex:0];
    [prevNext setPrevNextDelegate:self];

 
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [prevNext setUp:textField];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
       [prevNext setFields:[[NSMutableArray alloc] initWithObjects:titleField, priceField, locationField, phoneField, nil]];
    if ([indexPath section] == 0 && [indexPath row] == [prevNext currentIndex]-1) {
       [[[cell subviews] objectAtIndex:0] becomeFirstResponder];
        NSLog(@"meow");
    }
}
- (void)donePressed
{
    [self hideKeyboard];
}

-(void)prevNextPressed:(UITextField *)textField
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:[prevNext currentIndex] inSection:0];
    [[self tableView] scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle
                                    animated:YES];
    [textField becomeFirstResponder];
}

- (void)dismissList
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: // Details
            return 5;
            break;
        case 1: // Picture
            return 1;
            break;
        case 2: // List
            return 1;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0 && [indexPath row] == 3) {
        return 44;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%d",(arc4random() %1000)]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    // Make the cell unselectable
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[cell textLabel] setFont:[UIFont fontWithName:@"Museo Slab" size:16]];
    
    // Configure each form cell
    UITextField *tf = nil;
    [tf setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    tf.tag = [indexPath row];
    
    // Info
    if ([indexPath section] == 0) {
        switch ([indexPath row]) {
            case 0:
                [[cell textLabel] setText:@"Title"];
                tf = titleField = [self placeholder:@"Listing title"];
                [titleField setText:[self title]];
                [cell addSubview:titleField];
                break;
            case 1:
                [[cell textLabel] setText:@"Price"];
                tf = priceField = [self placeholder:@"Price (i.e. 25)"];
                [priceField setKeyboardType:UIKeyboardTypeDecimalPad];
                [priceField setText:[self price]];
                [cell addSubview:priceField];
                break;
            case 2:
                [[cell textLabel] setText:@"Location"];
                tf = locationField = [self placeholder:@"Location (i.e. Corrado)"];
                [locationField setText:[self location]];
                [cell addSubview:locationField];
                break;
            case 3:
                [[cell textLabel] setText:@"Phone"];
                tf = phoneField = [self placeholder:@"Optional xxxxxxxxx"];
                [phoneField setKeyboardType:UIKeyboardTypeDecimalPad];
                [phoneField setText:[self phone]];
                [cell addSubview:phoneField];
                break;
            case 4:
                [[cell textLabel] setText:@"Description"];
                tf = descriptionField = [self placeholder:@""];
                [tf setEnabled:NO];
                [cell addSubview:descriptionField];
                [descriptionField setText:[self descriptionItem]];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                break;
            }
    } else if ([indexPath section] == 1) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, 0, cell.frame.size.width, cell.frame.size.height)];
        if (![imageLabel text])
        [imageLabel setText:imageLabelText];
        [imageLabel setTextColor:imageLabelColor];
        [imageLabel setTextAlignment:NSTextAlignmentCenter];
        [imageLabel setBackgroundColor:[UIColor clearColor]];
        [imageLabel setFont:[UIFont fontWithName:@"Museo Slab" size:16]];

        [cell addSubview:imageLabel];
        
    } else if ([indexPath section] == 2) { // List Item
        [[cell textLabel] setText:@"List Item"];
        [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
        [[cell textLabel] setFont:[UIFont fontWithName:@"Museo Slab" size:18]];
        [cell setBackgroundColor:PURPLECOLOR];
        [[cell textLabel] setTextColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    // Configure the cell...
    [tf setFrame:CGRectMake(120, 12, 170, 30)];
    [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    
    return cell;
}

- (void)descriptionType:(NSDictionary *)descriptionInfo
{
    [[self listingType] addEntriesFromDictionary:descriptionInfo];
    NSLog(@"%@ %@ %@", [descriptionInfo objectForKey:@"text"], [descriptionInfo objectForKey:@"ISBN"], [descriptionInfo objectForKey:@"edition"]);
    
    NSLog(@"%@ %@ book info", [[self listingType] objectForKey:@"subject"], [[self listingType] objectForKey:@"course"]);
    [descriptionField setText:[descriptionInfo objectForKey:@"text"]];
    [self setDescriptionItem:[descriptionInfo objectForKey:@"text"]];
}

// Custom text field generator
- (UITextField *)placeholder:(NSString *)placeholder
{
    UITextField *tf = [[UITextField alloc] init];
    [tf setPlaceholder:placeholder];
    [tf setReturnKeyType:UIReturnKeyDone];
    [tf setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [tf setAutocorrectionType:UITextAutocorrectionTypeNo];
    [tf setAdjustsFontSizeToFitWidth:YES];
    [tf setInputAccessoryView:prevNext];
    [tf setDelegate:self];
    
    
    return tf;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   

  //  } else if (textField == priceField) {
//        [locationField becomeFirstResponder];
  //  } else if (textField == locationField) {
       // [self pushDescController];
   // }


    [self setTitle:[titleField text]];
    [self setLocation:[locationField text]];
    [self setPrice:[priceField text]];
    [self setPhone:[phoneField text]];
}

/* Limit the number of characters for different fields */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [[textField text] length] + [string length] - range.length;
    if (textField == titleField) {
        return !(newLength > 85);
    } else if (textField == priceField) {
        NSCharacterSet *myCharset = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            return ([myCharset characterIsMember:c] && !(newLength > 5));
        }
    } else if (textField == locationField) {
        return !(newLength > 25);
    } else if (textField == phoneField) {
        NSCharacterSet *myCharset = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
        return ([myCharset characterIsMember:c] && !(newLength > 10));
        }
    }
    return YES;
}

/* The description view */
- (void)pushDescController
{
    if ([self isTextbook]) {
        WMTextbookDescViewController *tbdvc = [[WMTextbookDescViewController alloc] init];
        [tbdvc setDescriptionDelegate:self];
        [tbdvc setSavedInfo:[self listingType]];
        [[self navigationController] pushViewController:tbdvc animated:YES];
        
    } else {
        WMDescriptionViewController *descriptionViewController = [[WMDescriptionViewController alloc] init];
        [descriptionViewController setDescriptionDelegate:self];
        [descriptionViewController setDefaultText:[self descriptionItem]];
        [[self navigationController] pushViewController:descriptionViewController animated:YES];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Picture taking
    if ([indexPath section] == 1) {
       /* if (![self image]) {
        // Let's create a Image Taker and take it for a walk :)
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // If our device has a camera, take a new picture!
        // Otherwise pick from library...
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        } else {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        [imagePicker setDelegate:self];
        
        // Place the image picker on screen
        [self presentViewController:imagePicker animated:YES completion:nil];
        } else { */
            WMMarketImageViewController *marketImageViewController = [[WMMarketImageViewController alloc] init];
            [marketImageViewController setUpdatedFurnitureImage:[self image]];
            [marketImageViewController setUpdatedImageDelegate:self];
        [self presentViewController:marketImageViewController animated:YES completion:nil];

        //}
    }
    
    if ([indexPath section] == 0 && [indexPath row] == 4) {
        [self pushDescController];
    } else if ([indexPath section] == 2) { // List Item
        
        // Check for some errors!
        NSMutableString *errors = [[NSMutableString alloc] initWithFormat:@""];

        if ([titleField text].length < 5) {
            [errors appendString:@"Enter a more descriptive title. "];
        }
        if ([priceField text].length == 0) {
            [errors appendString:@"Enter a price. "];
        }
        if ([locationField text].length < 1) {
            [errors appendString:@"Enter a location. "];
        }
        if ([self descriptionItem].length < 1) {
            [errors appendString:@"Add a description. "];
        }
        if ([phoneField text].length == 0) {
            [self setPhone:@"N/A"];
        }
        if (![self image]) {
            [errors appendString:@"Please add a picture. "];
        }
        
        
        if ([errors isEqualToString:@""]) {
            // Get the image and upload it to the cloud!!!!!
            PFFile *imageFile = [PFFile fileWithName:@"furnitureImage" data:[self imageData]];
            
            PFUser *user = [PFUser currentUser];
            
            // Create a furniture object
            WMGeneralListing *newListing = [[WMGeneralListing alloc] initWithTitle:[self title] price:[self price] description:[self descriptionItem] seller:user image:imageFile location:[self location] phone:[self phone] listDate:[NSDate date]];
            
            
            PFObject *newParseListing;
            if ([self isTextbook]) {
                newParseListing = [PFObject objectWithClassName:@"WMTextbook" dictionary:[newListing dictionary]];
                [newParseListing setObject:[[self listingType] objectForKey:@"course"] forKey:@"course"];
                [newParseListing setObject:[[self listingType] objectForKey:@"subject"] forKey:@"subject"];
                
                NSMutableString *desc = [[NSMutableString alloc] initWithString:[self descriptionItem]];
                if ([[self listingType] objectForKey:@"edition"] || [[self listingType] objectForKey:@"ISBN"]) {
                    [newParseListing setObject:[[self listingType] objectForKey:@"edition"] forKey:@"edition"];
                    [newParseListing setObject:[[self listingType] objectForKey:@"ISBN"] forKey:@"ISBN"];
                    [desc appendFormat:@"\n Edition: %@", [[self listingType] objectForKey:@"edition"]];
                    [desc appendFormat:@"\n ISBN: %@", [[self listingType] objectForKey:@"ISBN"]];
                }
                [newParseListing setObject:desc forKey:@"itemDescription"];
            } else if ([self isFurniture]) {
                newParseListing = [PFObject objectWithClassName:@"WMFurniture" dictionary:[newListing dictionary]];
            } else if ([self isOther]) {
                newParseListing = [PFObject objectWithClassName:@"WMOther" dictionary:[newListing dictionary]];
            } else if ([self isHousing]) {
                newParseListing = [PFObject objectWithClassName:@"WMHousing" dictionary:[newListing dictionary]];
            }
            
            PFACL *listingACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [listingACL setPublicReadAccess:YES];
            [listingACL setPublicWriteAccess:NO];
            [newParseListing setACL:listingACL];
            [newParseListing saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    successAlertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"You're listing was successfully added." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                    [successAlertView show];
                    
                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"There was a problem." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                    [av show];
                }
            }];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:errors delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == successAlertView) {
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get orginal image
    [self setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    
    // Set data
    [self setImageData:UIImageJPEGRepresentation([self image], 0.2f)];
    
    // Take image picker off screen
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)newImage:(UIImage *)newImg newData:(NSData *)newData
{
    [self setImage:newImg];
    [self setImageData:newData];
    [imageLabel setTextColor:[UIColor redColor]];
    imageLabelText = @"Retake Picture";
    imageLabelColor = [UIColor redColor];
    [imageLabel setText:@"Retake Picture"];
}

// Check listing type
- (BOOL)isTextbook { return [[[self listingType] objectForKey:@"listingType"] isEqualToString:@"textbook"]; }
- (BOOL)isFurniture { return [[[self listingType] objectForKey:@"listingType"] isEqualToString:@"furniture"]; }
- (BOOL)isOther { return [[[self listingType] objectForKey:@"listingType"] isEqualToString:@"other"]; }
- (BOOL)isHousing { return [[[self listingType] objectForKey:@"listingType"] isEqualToString:@"housing"]; }



// Workaround to hide keyboard when Done is tapped
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)textFieldFinished:(id)sender {
    [sender resignFirstResponder];
}
- (void)hideKeyboard
{
    [self.view endEditing:YES];
}


@end
