//
//  WMRegisterViewController.m
//  ParseStarterProject
//
//  Created by John Liedtke on 7/4/13.
//
//

#import "WMRegisterViewController.h"
#import "WMGenderSelectViewController.h"
#import "WMYearSelectViewController.h"
#import "WMConstants.h"

@interface WMRegisterViewController ()

@end

@implementation WMRegisterViewController

@synthesize schoolYear, major, fullName, email, password, gender;

// Override the init method
- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self setTitle:@"Sign Up"];
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
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissList)];
    [cancel setTintColor:PURPLECOLOR];
    [[self navigationItem] setLeftBarButtonItem:cancel];
    
    
    // Init keyboard crap
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"WMPrevNext" owner:self options:nil];
    prevNext = [subviewArray objectAtIndex:0];
    [prevNext setPrevNextDelegate:self];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}





- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [prevNext setUp:textField];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [prevNext setFields:[[NSMutableArray alloc] initWithObjects:fullNameField, emailField, passwordField, majorField, nil]];
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






-(void)dismissList
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Custom text field generator
- (UITextField *) makeTextField:(NSString *)text
placeholder:(NSString *)placeholder
{
    UITextField *tf = [[UITextField alloc] init];
    [tf setPlaceholder:placeholder];
    [tf setText:text];
    [tf setReturnKeyType:UIReturnKeyNext];
    [tf setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [tf setAutocorrectionType:UITextAutocorrectionTypeNo];
    [tf setAdjustsFontSizeToFitWidth:YES];
    [tf setInputAccessoryView:prevNext];
    [tf setTextColor:[UIColor purpleColor]];
    [tf setDelegate:self];
    
    
    return tf;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    // Make the cell unselectable
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[cell textLabel] setFont:[UIFont fontWithName:@"Museo Slab" size:16]];
    
    // Configure each form cell
    UITextField *tf = nil;
    
    if ([indexPath section] == 0) {
        switch ([indexPath row]) {
            case 0:
                [[cell textLabel] setText:@"Name"];
                tf = fullNameField = [self makeTextField:@"" placeholder:@"Full name"];
                [tf setAutocapitalizationType:UITextAutocapitalizationTypeWords];
                [cell addSubview:fullNameField];
                break;
            case 1:
                [[cell textLabel] setText:@"Email"];
                tf = emailField = [self makeTextField:@"" placeholder:@"UP Email"];
                [cell addSubview:emailField];
                break;
            case 2:
                [[cell textLabel] setText:@"Password"];
                tf = passwordField = [self makeTextField:@"" placeholder:@"Required"];
                [tf setSecureTextEntry:YES];
                [cell addSubview:passwordField];
                break;
            case 3:
                [[cell textLabel] setText:@"Major"];
                tf = majorField = [self makeTextField:@"" placeholder:@"i.e. Computer Science"];
                [tf setPlaceholder:@"Major"];
                [tf setReturnKeyType:UIReturnKeyDone];
                [cell addSubview: majorField];
                break;
        }
    } else if ([indexPath section] == 1) {
        [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
        [[cell textLabel] setFont:[UIFont fontWithName:@"Museo Slab" size:20]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        [[cell textLabel] setText:@"Sign Up"];
    }
    [tf setFrame:CGRectMake(120, 12, 170, 30)];
    [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //if (section == 0) {
      //  return @"Sign Up";
    //}
    return nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setFullName:[fullNameField text]];
    [self setEmail:[emailField text]];
    [self setPassword:[passwordField text]];
    [self setMajor:[majorField text]];
}

- (void)genderSelect:(NSString *)g
{
    [genderField setText:g];
    [self setGender:g];
}

- (void)yearSelect:(NSString *)year yearNumber:(int)number
{
    [schoolYearField setText:year];
    [self setSchoolYear:[NSNumber numberWithInt:number]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    // Sign up button
    if ([indexPath section] == 1 && [indexPath row] == 0) {
        NSMutableString *errors = [[NSMutableString alloc] initWithString:@""];
    
        // Check if valid email
        if ([[self email] rangeOfString:@"@up.edu"].location == NSNotFound || ![self email]) {
            [errors appendString:@"Not a valid UP email. "];
           NSLog(@"Invalid email");
        }
        if ([self fullName].length < 3) {
            [errors appendFormat:@"Please enter a real name. "];
        }
        if ([self password].length < 3) {
            [errors appendFormat:@"Please enter a password. "];
        }
        if ([self major].length < 1) {
            [errors appendFormat:@"Please enter a major. "];
        }
    
        // Error Pop UP
        if (![errors isEqualToString:@""]) {
            UIAlertView *formErrors = [[UIAlertView alloc] initWithTitle:@"Please fix the following" message:[NSString stringWithFormat:@"%@",errors] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [formErrors show];
            return;
        }
    
        // Make a new user!
        PFUser *newUser = [PFUser user];
        [newUser setUsername:[self email]];
        [newUser setPassword:[self password]];
        [newUser setEmail:[self email]];

         // Extra user info
        [newUser setObject:[self fullName] forKey:@"fullName"];
        [newUser setObject:[self major] forKey:@"major"];
        
         // Register the new user with parse!
         [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
                [[self registerDelegate] setUserName:@"Test"];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                // Show the errorString somewhere and let the user try again.
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Uh oh! Trouble!" message:[NSString stringWithFormat:@"%@ %@ %@", errorString, [newUser username], [self fullName]] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [errorAlert show];
            }
        }];
    
    } else if ([indexPath section] == 1 && [indexPath row] == 1) {
        [fullNameField setText:nil];
        [emailField setText:nil];
        [passwordField setText:nil];
        [genderField setText:nil];
        [schoolYearField setText:nil];
        [majorField setText:nil];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}


// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    [sender resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}


#pragma mark - Table view delegate




@end