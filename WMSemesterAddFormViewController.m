//
//  WMSemesterAddFormViewController.m
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/23/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import "WMSemesterAddFormViewController.h"
#define ACCEPTABLECHARACTERS @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 "
#import "WMConstants.h"

@interface WMSemesterAddFormViewController ()

@end

@implementation WMSemesterAddFormViewController

@synthesize semesterTitle = semesterTitle_ ;

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
    PURPLEBACK

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"courseCell"];
    }

    
    // Configure the cell...
    //Make the cell unselectable:
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //Create the text field:
    UITextField *tf = nil;
    
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"Semester Title:"];
            if (self.semesterTitle == Nil) {
                tf = semesterTitleField_= [self makeTextField:self.semesterTitle placeholder:@"Fall 2012"];
            }
            [cell addSubview:semesterTitleField_];
            break;
        case 1:
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            cell.textLabel.text = @"Submit";
            break;
        default:
            break;
    }
   
    
    tf.frame = CGRectMake(190, 8, 170, 30);
    [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    tf.delegate = self ;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        //Call the formSubmit Method:
        [self formSubmit];
    }
}

//This method is called when the submit button is pressed:
-(void) formSubmit
{
    //Dismiss the keyboard when this button is pressed:
    [self.view endEditing:YES];
    
    //TODO: Check and ensure that the semester title conforms to format:
    //not nil, is unique, and is of the format: @"string"_yyyy:
    BOOL checker = YES;
    NSMutableString *errorMessage = [[NSMutableString alloc] init];
    if(self.semesterTitle == nil || [self.semesterTitle isEqualToString:@""]){
        [errorMessage appendString:@"Please enter a semester title."];
        checker = NO;
    }
    
    //If it conforms to the format, check the name against what we have stored on core data, to make sure the user has entered a unique semester title:
    if (checker == YES) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
        
        [request setEntity:entity];
        
        
        NSError *error;
        NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if (array != nil) {
            for(Course *semesters in array){
                if([semesters.semesterTitle isEqualToString:[NSString stringWithFormat:@"%@", self.semesterTitle]]){
                    checker = NO;
                    break;
                }
            }
            [errorMessage appendString:@"Duplicate Semester Found. Please enter a unique semester name."];
        }
    }
    
    //NOTE: this is not the best way to do this, a better implementaiton
    //is advised:
    
    //Create an instance of a WMCourseObject and save its data: This will be a
    //course object where only the semester title field and one other field will be checked:
    //When using course objects, therefore one must take care not to display the semester objects.
    if (checker == YES) {
        
        WMCourseObject *newCourse = [[WMCourseObject alloc] init];
        
        [newCourse setSemesterTitle:self.semesterTitle];
        [newCourse setProfName:@""];
        [newCourse setManagedObjectContext:self.managedObjectContext];
        
        [newCourse saveData];
        //NSLog(@"Saved Data");
        
        //Send a reload message to the semesterViewController; call the delegate method:
        [[self.navigationController.viewControllers objectAtIndex:0]
         reloadData];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        //Print out an error message:
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Could not Submit." message: errorMessage delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [error show];
    }
}


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
	if ( textField == semesterTitleField_ ) {
		self.semesterTitle = textField.text ;
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

//This method ensures the user can't enter any illegal characters (#defined at the top)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if(textField == semesterTitleField_){
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLECHARACTERS];
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

//This method is used to create the section headers:
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Add a Semester:";
    }
    else{
        return @"MEWO";
    }
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
