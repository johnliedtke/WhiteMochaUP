//
//  WMRidesViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/8/13.
//
//

#import "WMRidesViewController.h"

@interface WMRidesViewController ()

@end

@implementation WMRidesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Keyboard crap
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"WMPrevNext" owner:self options:nil];
    prevNext = [subviewArray objectAtIndex:0];
    [prevNext setPrevNextDelegate:self];
    NSMutableArray *fields = [[NSMutableArray alloc] initWithObjects:toField,fromField,whenField,feeField, nil];
    [prevNext setFields:fields];
    for (UITextField *tf in fields) {
        [tf setInputAccessoryView:prevNext];
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
    [whenField setInputView:datePicker];
    
    [postLabel setFont:[UIFont fontWithName:@"Museo Slab" size:16.0]];
    

 
}

- (void)datePickerValueChanged
{
    NSDate *departDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, h:mm a"];
    NSString *theDate = [dateFormatter stringFromDate:departDate];
    [whenField setText:theDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath section] == 2) { // Post ride!
        
        // Check for some errors!
        NSMutableString *errors = [[NSMutableString alloc] initWithFormat:@""];
        
        if ([toField text].length < 1) {
            [errors appendString:@"Enter a \"to\" location. "];
        }
        if ([fromField text].length == 0) {
            [errors appendString:@"Enter \"from\" location. "];
        }
        if ([feeField text].length < 1) {
            [errors appendString:@"Enter a fee or \"free\". "];
        }
        if ([otherInfoTextView text].length < 1) {
            [errors appendString:@"Add some info! "];
        }
        if (![datePicker date]) {
            [errors appendString:@"Pick a depature date. "];
        }
        
        if ([errors isEqualToString:@""]) {
            

            
            // Create a WMRide object!
            PFObject *rideService = [PFObject objectWithClassName:@"WMRide"];

            // Add info
            [rideService setObject:[PFUser currentUser] forKey:@"rider"];
            [rideService setObject:[toField text] forKey:@"to"];
            [rideService setObject:[fromField text] forKey:@"from"];
            [rideService setObject:[datePicker date] forKey:@"departureDate"];
            [rideService setObject:[feeField text] forKey:@"fee"];
            [rideService setObject:[otherInfoTextView text] forKey:@"otherInfo"];

            // Some sexy security
            PFACL *listingACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [listingACL setPublicReadAccess:YES];
            [listingACL setPublicWriteAccess:NO];
            [rideService setACL:listingACL];
            [rideService saveInBackground];
            [[self navigationController] popToRootViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:errors delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:nil];
            [alert show];
        }
    }
}





@end
