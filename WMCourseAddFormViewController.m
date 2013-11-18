//
//  WMCourseAddFormViewController.m
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/23/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import "WMCourseAddFormViewController.h"

#define ACCEPTABLECOURSETITLECHARACTERS @"abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
#define ACCEPTABLEPROFNAMECHARACTERS @"abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ"
@interface WMCourseAddFormViewController ()

@end

@implementation WMCourseAddFormViewController

@synthesize courseTitle = courseTitle_;
@synthesize profName = profName_;
@synthesize numCredits = numCredits_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"courseCell"];
    }
    
    // Configure the cell...
    UITextField *tf = nil;
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"Course Title"];
            if (courseTitleField_ == nil) {
                tf = courseTitleField_ = [self makeTextField:self.courseTitle placeholder:@"EGR 110"];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:courseTitleField_];
            break;
        case 1:
            [cell.textLabel setText:@"Professor"];
            if (profNameField_ == nil) {
                tf = profNameField_ = [self makeTextField:self.profName placeholder:@"Hoffbeck"];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:profNameField_];
            break;
        case 2:
            [cell.textLabel setText:@"Number of Credits"];
            if (numCreditsField_ == nil) {
                tf = numCreditsField_ = [self makeTextField:self.numCredits placeholder:@"3"];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:numCreditsField_];
            break;
        case 3:
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setText:@"Submit"];
        default:
            break;
    }
    
    tf.frame = CGRectMake(190, 8, 170, 30);
    [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    tf.delegate = self;
    
    return cell;
}

//This method is called when the user selects something in the table view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        //Call the formSubmit Method:
        [self formSubmit];
    }
}

//This method is used to create the section headers:
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Add a Course";
    }
    else{
        return @"List of Courses";
    }
}

//This method is called when the submit button is pressed:
-(void) formSubmit
{
    //Dismiss the keyboard when this button is pressed:
    [self.view endEditing:YES];
    BOOL checker = YES;
    NSMutableString *errorMessage = [[NSMutableString alloc] init];
    if(self.courseTitle == nil || [self.courseTitle isEqualToString:@""]){
        [errorMessage appendString:@"Please enter a course title. "];
        checker = NO;
    }
    if (self.profName == nil || [self.profName isEqualToString:@""]) {
        [errorMessage appendString:@"Please enter a professor name."];
        checker = NO;
    }
    
    //If it conforms to the format, check the name against what we have stored on core data, to make sure the user has entered a unique course title:
    if (checker == YES) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
        
        [request setEntity:entity];
        
        
        NSError *error;
        NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if (array != nil) {
            for(Course *courses in array){
                if([courses.courseTitle isEqualToString:[NSString stringWithFormat:@"%@", self.courseTitle]] && [courses.semesterTitle isEqualToString:[NSString stringWithFormat:@"%@", self.title]]){
                    checker = NO;
                    break;
                }
            }
            [errorMessage appendString:@"Duplicate Course Found. Please enter a unique course name."];
        }
    }
    if (checker == YES) {
        //Create an instance of a WMCourseObject and save its data:
        WMCourseObject *objectToSave = [[WMCourseObject alloc] init];
        [objectToSave setManagedObjectContext:self.managedObjectContext];
        [objectToSave setCourseTitle:self.courseTitle];
        [objectToSave setSemesterTitle:self.title];
        [objectToSave setProfName:self.profName];
        [objectToSave setNumCredits:self.numCredits];
        [objectToSave saveData];
        
        //Send a reload message to the WMListOfCoursesViewController:
        [[self.navigationController.viewControllers objectAtIndex:1]
         reloadCourseData];
        
        //Go back a view controller:
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        //Print out an error message:
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Could not Submit." message: errorMessage delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [error show];
    }

    
}


#pragma mark- Text Field Methods:
-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
	UITextField *tf = [[UITextField alloc] init];
	tf.placeholder = placeholder ;
	tf.text = text ;
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
	tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    
	return tf ;
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    
}

//This method is called when the text field value has changed:
- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ( textField == courseTitleField_) {
		self.courseTitle = textField.text ;
	}
    else if (textField == profNameField_){
        self.profName = textField.text;
    }
    else if (textField == numCreditsField_){
        self.numCredits = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

//This method ensures the user can't enter any illegal characters (#defined at the top)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if(textField == courseTitleField_){
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLECOURSETITLECHARACTERS];
        NSInteger maxLength = 12;
        NSInteger maxStringLength = [textField.text length] + [replacementString length] -range.length;
        if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxStringLength >= maxLength) {
            return NO;
        }
        else{
            return YES;
        }
    }
    
    if (textField == profNameField_) {
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLEPROFNAMECHARACTERS];
        NSInteger maxLength = 12;
        NSInteger maxStringLength = [textField.text length] + [replacementString length] -range.length;
        if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxStringLength >= maxLength) {
            return NO;
        }
        else{
            return YES;
        }

    }
    return YES;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
