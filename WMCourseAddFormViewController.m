//
//  WMCourseAddFormViewController.m
//  ParseStarterProject
//
//  Created by Derek Schumacher on 7/27/13.
//
//

#import "WMCourseAddFormViewController.h"
#import <Parse/Parse.h>
#import "WMConstants.h"

#define ACCEPTABLEPROF_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ."
#define ACCEPTABLECOURSETITLE_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ACCEPTABLECOURSENUMBER_CHARACTERS @"0123456789"
@interface WMCourseAddFormViewController ()

@end

@implementation WMCourseAddFormViewController
@synthesize profName = profName_ ;
@synthesize courseTitle = courseTitle_;
@synthesize courseNumber = courseNumber_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Add Course"];
    PURPLEBACK
    
    // Init keyboard crap
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"WMPrevNext" owner:self options:nil];
    prevNext = [subviewArray objectAtIndex:0];
    [prevNext setPrevNextDelegate:self];
    
    /*
     self.profName = @"";
     self.courseTitle = @"";
     self.courseNumber = @"";
     */
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0){
        return 3;
    }
    else{
        return 1;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [prevNext setUp:textField];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [prevNext setFields:[[NSMutableArray alloc] initWithObjects:profNameField_,courseTitleField_, courseNumberField_, nil]];
    if ([indexPath section] == 0 && [indexPath row] == [prevNext currentIndex]-1) {
        [[[cell subviews] objectAtIndex:0] becomeFirstResponder];
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
    [[self tableView] scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle
                                    animated:YES];
    [textField becomeFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    // Configure the cell...
    //make the cell unselectable:
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField *tf = nil;
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Professor";
                if (profNameField_ == nil) {
                    tf = profNameField_ = [self makeTextField:self.profName placeholder:@"Dr. Meow"];
                    [tf setAutocapitalizationType:UITextAutocapitalizationTypeSentences];

                }
                [cell addSubview:profNameField_];
                break;
            case 1:
                cell.textLabel.text = @"Course Title";
                if (courseTitleField_ == nil) {
                    tf = courseTitleField_ = [self makeTextField:self.courseTitle placeholder:@"MTH"];
                    [tf setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];

                }
                [cell addSubview:courseTitleField_];
                break;
            case 2:
                cell.textLabel.text = @"Course Number";
                if (courseNumberField_ == nil) {
                    tf = courseNumberField_ = [self makeTextField:self.courseNumber placeholder:@"101"];
                    [courseNumberField_ setKeyboardType:UIKeyboardTypeDecimalPad];
                }
                [cell addSubview:courseNumberField_];
                break;
            default:
                break;
        }
    }
    
    tf.frame = CGRectMake(160, 12, 170, 30);
    [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    tf.delegate = self ;
    if(indexPath.section == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        cell.textLabel.text = @"Submit";
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        //Dismiss the keyboard:
        [self.view endEditing:YES];
        
        NSString *profName = self.profName;
        NSString *courseTitle = self.courseTitle;
        NSString *courseNumber = self.courseNumber;
        
        NSMutableString *errorMessageString = [[NSMutableString alloc] init];
        errorMessageString = [NSMutableString stringWithFormat:@""];
        
        if (profName == nil || [profName isEqualToString:@""]) {
            [errorMessageString appendString:@"Please Enter a Valid Professor Name. "];
        }
        if (courseTitle == nil || [courseTitle isEqualToString:@""]) {
            [errorMessageString appendString:@"Please Enter a Valid Course Title. "];
        }
        if (courseNumber == nil || [courseNumber isEqualToString:@""]) {
            [errorMessageString appendString:@"Please Enter a Valid Course Number. "];
        }
        
        NSString *courseName = [NSString stringWithFormat:@"%@ %@", courseTitle, courseNumber];
        
        if(profName && courseTitle && courseNumber && ![profName isEqualToString:@""] && ![courseTitle isEqualToString:@""] && ![courseNumber isEqualToString:@""]){
            //Make sure the courseTitle and number are unique:
            //Find the course Object on the core, and compare:
            //Pull the info off the core:
            NSManagedObjectContext *context = [self managedObjectContext];
            NSError *error;
            NSFetchRequest *request= [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
            [request setEntity:entity];
            NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
            BOOL checker = YES;
            for (Course *courses in fetchedObjects) {
                if ([courses.courseTitle isEqualToString: [NSString stringWithFormat:@"%@ %@" ,self.courseTitle, self.courseNumber]]) {
                    
                    checker = NO;
                    [errorMessageString appendString:@"Please Enter a Unique Course Title (course name/number combination)"];
                }
            }
            if (checker == YES) {
                //Add the object to the Core:
                //NSManagedObjectContext *context = [self managedObjectContext];
                Course *course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
                [course setCourseTitle:courseName];
                [course setProfessorName:profName];
                
                //NSError *error;
                if (![context save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
                [self.managedObjectContext save:&error];
                /*
                 PFObject *courseObject = [PFObject objectWithClassName:@"Course"];
                 [courseObject setObject: profName forKey:@"ProfessorName"];
                 [courseObject setObject: courseName forKey:@"CourseTitle"];
                 //[courseObject setObject:courseNumber forKey:@"CourseNumber"];
                 [courseObject saveInBackground];
                 */
                
                
                //Call the delegate method to pass the course name:
                [[self courseDelegate] addCourse:courseName];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Course was successfully added." delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
                [success show];
            }
                else{
                    //Display error message:
                    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message: errorMessageString delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
                    [error show];
                }
        }
        else{
            //Display error message:
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message: errorMessageString delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [error show];

        }
        
    }
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Any additional checks to ensure you have the correct textField here.
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if (textField == profNameField_) {
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLEPROF_CHARACTERS];
        NSInteger maxLength = 25;
        NSInteger maxProfNameLength = [textField.text length] + [replacementString length] -range.length;
        if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxProfNameLength >= maxLength) {
            return NO;
            
        }
        else{
            return YES;
        }
        
    }
    if (textField == courseTitleField_) {
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLECOURSETITLE_CHARACTERS];
        NSInteger maxLength = 5;
        NSInteger maxProfNameLength = [textField.text length] + [replacementString length] -range.length;
        if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxProfNameLength >= maxLength) {
            return NO;
            
        }
        else{
            return YES;
        }
    }
    if (textField == courseNumberField_) {
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLECOURSENUMBER_CHARACTERS];
        NSInteger maxLength = 4;
        NSInteger maxProfNameLength = [textField.text length] + [replacementString length] -range.length;
        if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxProfNameLength >= maxLength) {
            return NO;
            
        }
        else{
            return YES;
        }
    }
    return YES;
}

-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
	UITextField *tf = [[UITextField alloc] init];
	tf.placeholder = placeholder ;
	tf.text = text ;
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
    [tf setInputAccessoryView:prevNext];
	tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
	return tf ;
}
// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}
// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //************************* Insert Error Checking *************************************************
	if ( textField == profNameField_ ) {
		self.profName = textField.text ;
	} else if ( textField == courseTitleField_ ) {
		self.courseTitle = textField.text ;
	} else if ( textField == courseNumberField_ ) {
		self.courseNumber = textField.text ;
	}
}

@end

