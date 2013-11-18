//
//  WMCourseAddGradeViewController.m
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/30/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import "WMCourseAddGradeViewController.h"
#define ACCEPABLESCORECHARACTERS @"1234567890"
#define ACCEPTABLENAMECHARACTERS @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789"
#define ACCEPABLEASSIGNMENTTYPECHARACTERS @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQ RSTUVWXYZ "
@interface WMCourseAddGradeViewController ()

@end

@implementation WMCourseAddGradeViewController
@synthesize assignmentName = assignmentName_;
@synthesize assignmentScore = assignmentScore_;
@synthesize maximumPoints = maximumPoints_;
@synthesize assignmentType = assignmentType_;

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
    return 5;
}

//This method is used to create the section headers:
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Add Assignment Score";
    }
    return @"";
}


//This method is called when a section (indexPath.row) is clicked on by the user:
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        [self submit];
    }
}

-(void) submit
{
    //Dismiss keyboard when button is pressed:
    [self.view endEditing:YES];
    
    //Search memory and see if a duplicate object already exists:
    bool checker = YES;
    NSMutableString *errorString = [[NSMutableString alloc] init];
    //Make sure the users input is valid:
    //Start with the most stringent thing:
    if ([self.assignmentType isEqualToString:@"Quiz"] || [self.assignmentType isEqualToString:@"quiz"] || [self.assignmentType isEqualToString:@"test"] || [self.assignmentType isEqualToString:@"Test"] || [self.assignmentType isEqualToString:@"essay"] || [self.assignmentType isEqualToString:@"Essay"] || [self.assignmentType isEqualToString:@"hw"] || [self.assignmentType isEqualToString:@"HW"] || [self.assignmentType isEqualToString:@"Attendance"] || [self.assignmentType isEqualToString:@"attendance"] || [self.assignmentType isEqualToString:@"Participation"] || [self.assignmentType isEqualToString:@"participation"] || [self.assignmentType isEqualToString:@"Final"] || [self.assignmentType isEqualToString:@"final"] || [self.assignmentType isEqualToString:@"Other"] || [self.assignmentType isEqualToString:@"Other"] ) {
        checker = YES;
    }
    else{
        checker = NO;
        [errorString appendString:@"Sorry, assignment type has to be one of these: Quiz, Test, Essay, HW, Attendance, Participation, Final, or Other."];
    }
    if (checker) {
        if ([self.assignmentScore isEqualToString:@""] || [self.assignmentName isEqualToString:@""]|| [self.maximumPoints isEqualToString:@""] || self.assignmentScore == nil || self.assignmentName == nil || self.maximumPoints == nil) {
            checker = NO;
            [errorString appendString:@"Please fill out form completely."];
        }
    }
    if (checker == YES) {
        //Pull the course object with this title out of memory:
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Grades" inManagedObjectContext:self.managedObjectContext];
        
        [request setEntity:entity];
        
        //TODO: Make sure this actually works
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.courseTitle like %@",self.title];
        
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (array != nil) {
            for (Grades *gradeObjects in array){
                if ([gradeObjects.assignmentName isEqualToString:self.assignmentName]) {
                    checker = NO;
                    [errorString appendString:@"Sorry, an assignment with this name has already been entered for this course."];
                    break;
                }
            }
        }
    }
    //If checker is still YES, that means there is no duplicates (or other problems with the input), so we can save the grade object to the memory:
    if (checker == YES) {
        NSError *error;
        Grades *objectToBeSaved = [NSEntityDescription insertNewObjectForEntityForName:@"Grades" inManagedObjectContext:self.managedObjectContext];
        [objectToBeSaved setAssignmentName:self.assignmentName];
        [objectToBeSaved setAssignmentScore:self.assignmentScore];
        [objectToBeSaved setCourseTitle:self.title];
        [objectToBeSaved setMaxPoints:self.maximumPoints];
        [objectToBeSaved setAssignmentType:self.assignmentType];
        [self.managedObjectContext save:&error];
        
        //Send a reload message to the view controller (use a delegate method), then pop back to it:
        [[self.navigationController.viewControllers objectAtIndex:2]
         reloadGradesData];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else{
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", errorString] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [errorMessage show];
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"courseCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the cell...
    UITextField * tf;
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"Assignment Name"];
            if (assignmentNameField_ == nil) {
                tf = assignmentNameField_ = [self makeTextField:self.assignmentName placeholder:@"Homework 1"];
            }
            [cell addSubview:tf];
            break;
        case 1:
            [cell.textLabel setText:@"Points Earned"];
            if (assignmentScoreField_ == nil) {
                tf = assignmentScoreField_ = [self makeTextField:self.assignmentScore placeholder:@"75"];
            }
            [cell addSubview:tf];
            break;
        case 2:
            [cell.textLabel setText:@"Maximum Points"];
            if (maximumPointsField_ == nil) {
                tf = maximumPointsField_ = [self makeTextField:self.maximumPoints placeholder:@"100"];
            }
            [cell addSubview:tf];
            break;
        case 3:
            [cell.textLabel setText:@"Assignment Type"];
            if (assignmentTypeField_ == nil) {
                tf = assignmentTypeField_ = [self makeTextField:self.assignmentType placeholder:@"Quiz"];
            }
            [cell addSubview:tf];
            break;
        case 4:
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            [cell.textLabel setText:@"Submit"];
            break;
        default:
            break;
    }
    tf.frame = CGRectMake(190, 8, 170, 30);
    [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    tf.delegate = self;
    
    return cell;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    //[sender resignFirstResponder];
}

//This method is called when the text field value has changed:
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
	if ( textField == assignmentScoreField_) {
		self.assignmentScore = textField.text ;
	}
    else if (textField == assignmentNameField_){
        self.assignmentName = textField.text;
    }
    else if (textField == maximumPointsField_){
        self.maximumPoints = textField.text;
    }
    else if (textField == assignmentTypeField_){
        self.assignmentType = textField.text;
    }
   
}

//This method ensures the user can't enter any illegal characters (#defined at the top)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if(textField == assignmentScoreField_){
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPABLESCORECHARACTERS];
        NSInteger maxLength = 12;
        NSInteger maxStringLength = [textField.text length] + [replacementString length] -range.length;
        if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxStringLength >= maxLength) {
            return NO;
        }
        else{
            return YES;
        }
    }
    
    if (textField == assignmentNameField_) {
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLENAMECHARACTERS];
        NSInteger maxLength = 12;
        NSInteger maxStringLength = [textField.text length] + [replacementString length] -range.length;
        if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxStringLength >= maxLength) {
            return NO;
        }
        else{
            return YES;
        }
        
    }
    
    if (textField == maximumPointsField_) {
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPABLESCORECHARACTERS];
        NSInteger maxLength = 12;
        NSInteger maxStringLength = [textField.text length] + [replacementString length] -range.length;
        if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxStringLength >= maxLength) {
            return NO;
        }
        else{
            return YES;
        }
        
    }
    
    if (textField == assignmentTypeField_) {
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPABLEASSIGNMENTTYPECHARACTERS];
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
