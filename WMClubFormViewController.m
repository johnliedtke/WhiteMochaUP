//
//  WMClubFormViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/15/13.
//
//

#import "WMClubFormViewController.h"
#import "WMConstants.h"

@interface WMClubFormViewController ()

@end

@implementation WMClubFormViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide the keyboard when pressed outside text field
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    // Title
    [self setTitle:@"Add Event"];
    
    // Find out the path of clubs.plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"clubs" ofType:@"plist"];
    clubs = [[NSDictionary alloc] initWithContentsOfFile:path];
    clubType = [[NSArray alloc] initWithObjects:@"Meeting", @"Event", nil];

    // Init keyboard crap
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"WMPrevNext" owner:self options:nil];
    prevNext = [subviewArray objectAtIndex:0];
    [prevNext setPrevNextDelegate:self];
    NSMutableArray *fields = [[NSMutableArray alloc] initWithObjects:clubField, dateField, locationField, typeField, nil];
    [prevNext setFields:fields];
    for (UITextField *tf in fields) [tf setInputAccessoryView:prevNext];
    
    // Club picker
    clubPicker = [[UIPickerView alloc] init];
    [clubPicker setDataSource:self];
    [clubPicker setDelegate:self];
    [clubPicker setShowsSelectionIndicator:YES];
    [clubField setInputView:clubPicker];
    
    // Club Type picker
    clubTypePicker = [[UIPickerView alloc] init];
    [clubTypePicker setDataSource:self];
    [clubTypePicker setDelegate:self];
    [clubTypePicker setShowsSelectionIndicator:YES];
    [typeField setInputView:clubTypePicker];
    [typeField setText:clubType[[clubTypePicker selectedRowInComponent:0]]];
    
    
    // Date Picker
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [dateField setInputView:datePicker];
    
    [postLabel setFont:[UIFont fontWithName:@"Museo Slab" size:17]];

    
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

// Pickers
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == clubPicker) return 2;
    if (pickerView == clubTypePicker) return 1;
    return 1;
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == clubPicker) {
        
        if (component == 0) {
            switch (row) {
                case 0:
                    return @"Academic Clubs";
                    break;
                case 1:
                    return @"Club Sports";
                    break;
                case 2:
                    return @"Multicultural Clubs";
                    break;
                case 3:
                    return @"Special Interest Groups";
                    break;
            }
        } else if (component == 1){
            switch ([clubPicker selectedRowInComponent:0]) {
                case 0:
                    return [[[clubs objectForKey:@"academic"] objectAtIndex:row] objectForKey:@"name"];
                    break;
                case 1:
                    return [[[clubs objectForKey:@"clubSports"] objectAtIndex:row] objectForKey:@"name"];
                    break;
                case 2:
                    return [[[clubs objectForKey:@"diversity"] objectAtIndex:row] objectForKey:@"name"];
                    break;
                case 3:
                    return [[[clubs objectForKey:@"special"] objectAtIndex:row] objectForKey:@"name"];
                    break;
            }
        }
    } else if (pickerView == clubTypePicker) {
        return clubType[row];
    }
    return @"meow";
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == clubPicker) {
        if (component == 0) {
            return 4;
        }
        
//        switch ([clubPicker selectedRowInComponent:0]) {
//            case 0:
//                return [[clubs objectForKey:@"academic"] count];
//                break;
//            case 1:
//                return [[clubs objectForKey:@"clubSports"] count];
//                break;
//            case 2:
//                return [[clubs objectForKey:@"diversity"] count];
//                break;
//            case 3:
//                return [[clubs objectForKey:@"special"] count];
//                break;
//        }
        return 30;
    } else if (pickerView == clubTypePicker) {
        return 2;
    }
    return 0;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == clubPicker) {
        if (component == 0) {
           [clubPicker selectRow:0 inComponent:1 animated:YES];
           [clubPicker reloadComponent:1];
          
        }
        if (component == 1) {
            if ([clubPicker selectedRowInComponent:0] == 0 && row >[[clubs objectForKey:@"academic"] count]-1) {
                [clubPicker selectRow:[[clubs objectForKey:@"academic"] count]-1 inComponent:1 animated:NO]; return;
            } else if ([clubPicker selectedRowInComponent:0] == 1 && row >[[clubs objectForKey:@"clubSports"] count]-1) {
                 [clubPicker selectRow:[[clubs objectForKey:@"clubSports"] count]-1 inComponent:1 animated:NO]; return;
            } else if ([clubPicker selectedRowInComponent:0] == 2 && row >[[clubs objectForKey:@"diversity"] count]-1) {
                 [clubPicker selectRow:[[clubs objectForKey:@"diversity"] count]-1 inComponent:1 animated:NO]; return;
            } else if ([clubPicker selectedRowInComponent:0] == 3 && row >[[clubs objectForKey:@"special"] count]-1) {
                 [clubPicker selectRow:[[clubs objectForKey:@"special"] count]-1 inComponent:1 animated:NO]; return;
            }
            
            [clubField setText:[[[clubs objectForKey:[self categoryKey]] objectAtIndex:row] objectForKey:@"name"]];
        }
    } else if (pickerView == clubTypePicker) {
        [typeField setText:clubType[row]];
    }
}


- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == clubPicker) {
        NSMutableAttributedString *attributedString;
        if (component == 0) {
            switch (row) {

                case 0:
                    attributedString = [[NSMutableAttributedString alloc] initWithString:@"Academic Clubs"];
                    break;
                case 1:
                    attributedString = [[NSMutableAttributedString alloc] initWithString:@"Club Sports"];
                    break;
                case 2:
                    attributedString = [[NSMutableAttributedString alloc] initWithString:@"Multicultural Clubs"];
                    break;
                case 3:
                    attributedString = [[NSMutableAttributedString alloc] initWithString:@"Special Interests"];
                    break;
            }
        } else if (component == 1){
            if ([clubPicker selectedRowInComponent:0] == 0 && row >[[clubs objectForKey:@"academic"] count]-1) {
                attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
                return attributedString;
            } else if ([clubPicker selectedRowInComponent:0] == 1 && row >[[clubs objectForKey:@"clubSports"] count]-1) {
                attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
                return attributedString;
            } else if ([clubPicker selectedRowInComponent:0] == 2 && row >[[clubs objectForKey:@"diversity"] count]-1) {
                attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
                return attributedString;
            } else if ([clubPicker selectedRowInComponent:0] == 3 && row >[[clubs objectForKey:@"special"] count]-1) {
                attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
                return attributedString;
            }

            switch ([clubPicker selectedRowInComponent:0]) {
                case 0:
                    attributedString = [[NSMutableAttributedString alloc] initWithString:[[[clubs objectForKey:@"academic"] objectAtIndex:row] objectForKey:@"name"]];
                    break;
                case 1:
                    attributedString = [[NSMutableAttributedString alloc] initWithString:[[[clubs objectForKey:@"clubSports"] objectAtIndex:row] objectForKey:@"name"]];
                    break;
                case 2:
                    attributedString = [[NSMutableAttributedString alloc] initWithString:[[[clubs objectForKey:@"diversity"] objectAtIndex:row] objectForKey:@"name"]];
                    break;
                case 3:
                    attributedString = [[NSMutableAttributedString alloc] initWithString:[[[clubs objectForKey:@"special"] objectAtIndex:row] objectForKey:@"name"]];
                    break;
                default:
                    break;
            }
        }
        
        if (component == 0)
            [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(0, attributedString.length)];
        else
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, attributedString.length)];

        return attributedString;
    }
   return nil;
}


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
    if (textField == locationField) {
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
        

       if ([locationField text].length < 1) {
           [errors appendString:@"Enter a location. "];
        }
        if ([clubField text]) {
            
            
        }
        if ([detailsTextView text].length < 5) {
            [errors appendString:@"Add some details!"];
        }

        
        
        if ([errors isEqualToString:@""]) {
            PFObject *club = [PFObject objectWithClassName:@"WMEvent"];
            
            // Set stuff
            
            // Event type
            [club setObject:CLUBS forKey:@"eventType"];
            
            // The club
            [club setObject:[[[clubs objectForKey:[self categoryKey]] objectAtIndex:[clubPicker selectedRowInComponent:1]] objectForKey:@"name"] forKey:@"club"];
            
            // Club category
            [club setObject:[self categoryKey] forKey:@"clubCategory"];
            [club setObject:[datePicker date] forKey:@"eventDate"];
            [club setObject:[locationField text] forKey:@"location"];
            [club setObject:[detailsTextView text] forKey:@"details"];
            [club setObject:[PFUser currentUser] forKey:@"user"];
            [club setObject:[typeField text] forKey:@"meeting"];
            
            PFACL *listingACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [listingACL setPublicReadAccess:YES];
            [listingACL setPublicWriteAccess:NO];
            [club setACL:listingACL];
            [club saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
         
- (NSString *)categoryKey
{
    int firstRow = [clubPicker selectedRowInComponent:0];
    switch (firstRow) {
        case 0:
            return @"academic";
        case 1:
            return @"clubSports";
        case 2:
            return @"diversity";
        case 3:
            return @"special";
    }
    return nil;
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
