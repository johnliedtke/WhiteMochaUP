//
//  WMAddEventFormViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/19/13.
//
//

#import "WMAddEventFormViewController.h"
#import "WMConstants.h"

@interface WMAddEventFormViewController ()

@end

@implementation WMAddEventFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide the keyboard when pressed outside text field
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    // Title
    [self setTitle:@"Add Event"];
    
    // Init keyboard crap
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"WMPrevNext" owner:self options:nil];
    prevNext = [subviewArray objectAtIndex:0];
    [prevNext setPrevNextDelegate:self];
    NSMutableArray *fields = [[NSMutableArray alloc] initWithObjects:eventField, dateField,locationField, sponsorField,nil];
    [prevNext setFields:fields];
    for (UITextField *tf in fields) [tf setInputAccessoryView:prevNext];
    
    
    // Date Picker
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [dateField setInputView:datePicker];
    
    // Appearance
    PURPLEBACK
    [postEventLabel setFont:[UIFont fontWithName:@"Museo Slab" size:18]];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,5, 100, 30)];
    [headerView addSubview:label];
    [label setFont:[UIFont fontWithName:@"Museo Slab" size:18]];
    [label setBackgroundColor:[UIColor clearColor]];
    
    switch (section) {
        case 0:
            [label setText:@"Details"];
            break;
        case 1:
            [label setFrame:CGRectMake(15,-5, 100, 30)];
            [label setText:@"Other info"];
            break;
        default:
            break;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{   if (section == 0)
    return 35;
else if (section == 1)
    return 30;
    return 0;
}

// Date Picker
- (void)datePickerValueChanged
{
    NSDate *departDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, h:mm a"];
    NSString *theDate = [dateFormatter stringFromDate:departDate];
    [dateField setText:theDate];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [prevNext setUp:textField];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* Limit the number of characters for different fields */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [[textField text] length] + [string length] - range.length;
    if (textField == locationField || textField == sponsorField || textField == eventField) {
        return !(newLength > 45);
    }
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 2) { // List Item
        
        // Check for some errors!
        NSMutableString *errors = [[NSMutableString alloc] initWithFormat:@""];
        
        if ([eventField text].length < 2) {
            [errors appendString:@"Enter an event title. "];
        }
        if ([locationField text].length < 1) {
            [errors appendString:@"Enter a location. "];
        }
        if ([dateField text].length < 1) {
            [errors appendString:@"Select a date. "];
        }
        if ([detailsTextView text].length < 5) {
            [errors appendString:@"Add some details!"];
        }
        
        
        
        if ([errors isEqualToString:@""]) {
            PFObject *event = [PFObject objectWithClassName:@"WMEvent"];
            
            // Set stuff
            
            // Event type
            [event setObject:[self eventType] forKey:@"eventType"];
            

            // Club Stuff
            [event setObject:[eventField text] forKey:@"title"];
            [event setObject:[datePicker date] forKey:@"eventDate"];
            [event setObject:[locationField text] forKey:@"location"];
            [event setObject:[detailsTextView text] forKey:@"details"];
            [event setObject:[PFUser currentUser] forKey:@"user"];
            if ([sponsorField text]) {
                [event setObject:[sponsorField text] forKey:@"sponsor"];
            }

            PFACL *listingACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [listingACL setPublicReadAccess:YES];
            [listingACL setPublicWriteAccess:NO];
            [event setACL:listingACL];
            [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIAlertView *av;
                if (succeeded) {
                    [[self addEventDelegate] eventAdded];
                    [[self navigationController] popToRootViewControllerAnimated:YES];
                } else {
                    av = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                    [av show];
                }
            }];
            [[self navigationController] popToRootViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:errors delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:nil];
            [alert show];
        }
    }
}

// Workaround to hide keyboard when Done is tapped
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

@end
