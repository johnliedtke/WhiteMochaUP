//
//  WMEventDetailViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/19/13.
//
//

#import "WMEventDetailViewController.h"
#import "WMConstants.h"

@interface WMEventDetailViewController ()

@end

@implementation WMEventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [titleField setText:[[self event] title]];
    [locationField setText:[[self event] location]];

    // date
    NSDate *departDate = [[self event] eventDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, h:mm a"];
    [timeField setText:[dateFormatter stringFromDate:departDate]];
    
    // details
    [detailsTextView setText:[[self event] details]];
    
    // created
    PFUser *creator = [[self event]  user];
    NSString *objectID = [creator objectId];
    
    [[PFUser query] getObjectInBackgroundWithId:objectID block:^(PFObject *object, NSError *error) {
        [creatorField setText:[object objectForKey:@"fullName"]];
        // Edit the listing
        if ([objectID isEqualToString:[[PFUser currentUser] objectId]]) {
            editFields = [[NSArray alloc] initWithObjects:titleField,locationField,timeField,creatorField,sponsorField,detailsTextView, nil];
            editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editListing)];
            [editButton setTintColor:PURPLECOLOR];
            [[self navigationItem] setRightBarButtonItem:editButton];
        }
    }];
    
    // Hide the keyboard when pressed outside text field
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(donePressed)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setDate:[[self event] eventDate]];
    [timeField setInputView:datePicker];
    
    
    // Navigation
    [[self navigationItem] setLeftItemsSupplementBackButton:YES];
    
    
    if ([[self event] sponsor]) {
        [sponsorField setText:[[self event] sponsor]];
    } else {
        [sponsorField setText:@"N/A"];
    }
    
    [self setTitle:@"Events"];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)editListing
{
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(doneEditing)];
    [doneButton setTintColor:PURPLECOLOR];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    editButton = nil;
    deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteRide)];
    [deleteButton setTintColor:PURPLECOLOR];
    [[self navigationItem] setLeftBarButtonItem:deleteButton];
    
    for (UITextField *tf in editFields) {
        if ([tf isKindOfClass:[UITextView class]]) {
            [detailsTextView setEditable:YES];
        } else {
            [tf setEnabled:YES];
        }
    }
    
    // Save the current state
    [self setTitleEvent:[titleField text]];
    [self setLocation:[locationField text]];
    [self setSponsor:[sponsorField text]];
    [self setDetails:[detailsTextView text]];
    [self setTime:[timeField text]];
}

- (void)deleteRide
{
    [[[self event] parseObject] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        UIAlertView *av;
        if (succeeded) {
            av = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Event has been deleted" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [av show];
            [[self navigationController] popViewControllerAnimated:YES];
        } else {
            av = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error description] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [av show];
        }
    }];

}

- (void)doneEditing
{
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editListing)];
    [editButton setTintColor:PURPLECOLOR];
    [[self navigationItem] setRightBarButtonItem:editButton];
    doneButton = nil;
    deleteButton = nil;
    
    [[self navigationItem] setLeftBarButtonItem:nil];
    
    // Disable again
    for (UITextField *tf in editFields) {
        if ([tf isKindOfClass:[UITextView class]]) {
            [detailsTextView setEditable:NO];
        } else {
            [tf setEnabled:NO];
        }
    }
    
    // Only save if there were changes
    if (![[[self event] title] isEqualToString:[titleField text]] || ![[self location] isEqualToString:[locationField text]] || ![[self time] isEqualToString:[timeField text]] || ![[self sponsor] isEqualToString:[sponsorField text]] || [[self details] isEqualToString:[detailsTextView text]]) {

        [[[self event] parseObject] setObject:[titleField text] forKey:@"title"];
        [[[self event] parseObject] setObject:[locationField text] forKey:@"location"];
        [[[self event] parseObject] setObject:[datePicker date] forKey:@"eventDate"];
        [[[self event] parseObject] setObject:[sponsorField text] forKey:@"sponsor"];
        [[[self event] parseObject] setObject:[detailsTextView text] forKey:@"details"];
        

        [[[self event] parseObject] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            UIAlertView *av;
            if (succeeded) {
                av = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Listing has been updated. Refresh events to see changes." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [av show];
            } else {
                av = [[UIAlertView alloc] initWithTitle:@"Error :(" message:[error description] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [av show];
            }
        }];
    }
}

-(void)donePressed
{
    [[self view] endEditing:YES];
}


- (void)datePickerValueChanged
{
    NSDate *departDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, h:mm a"];
    NSString *theDate = [dateFormatter stringFromDate:departDate];
    [timeField setText:theDate];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
