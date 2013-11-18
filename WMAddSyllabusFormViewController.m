//
//  WMAddSyllabusFormViewController.m
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/30/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import "WMAddSyllabusFormViewController.h"

#define ACCEPTABLEWEIGHTCHARACTERS @"1234567890"
@interface WMAddSyllabusFormViewController ()

@end

@implementation WMAddSyllabusFormViewController

@synthesize hwWeight = hwWeight_;
@synthesize quizWeight = quizWeight_;
@synthesize essayWeight = essayWeight_;
@synthesize testWeight = testWeight_;
@synthesize attendanceWeight = attendanceWeight_;
@synthesize finalExamWeight = finalExamWeight_;
@synthesize otherWeight = otherWeight_;


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

//This method is used to create the section headers:
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Add Syllabus Information";
    }
    return @"";
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
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"courseCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UITextField *tf = nil;
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"Quiz Weight"];
            if (quizWeightField_ == nil) {
                tf = quizWeightField_ = [self makeTextField:self.quizWeight placeholder:@"10 %"];
            }
            [cell addSubview:quizWeightField_];
            break;
        case 1:
            [cell.textLabel setText:@"Test Weight"];
            if (testWeightField_ == nil) {
                tf = testWeightField_ = [self makeTextField:self.testWeight placeholder:@"20 %"];
            }
            [cell addSubview:testWeightField_];
            break;
        case 2:
            [cell.textLabel setText:@"Essay Weight"];
            if (essayWeightField_ == nil) {
                tf = essayWeightField_ = [self makeTextField:self.essayWeight placeholder:@"30 %"];
            }
            [cell addSubview:essayWeightField_];
            break;
        case 3:
            [cell.textLabel setText:@"Homework Weight"];
            if (hwWeightField_ == nil) {
                tf = hwWeightField_ = [self makeTextField:self.hwWeight placeholder:@"10 %"];
            }
            [cell addSubview:hwWeightField_];
            break;
        case 4:
            [cell.textLabel setText:@"Attendance Weight"];
            if (attendanceWeightField_ == nil) {
                tf = attendanceWeightField_ = [self makeTextField:self.attendanceWeight placeholder:@"10 %"];
            }
            [cell addSubview:attendanceWeightField_];
            break;
        case 5:
            [cell.textLabel setText:@"Other Weight"];
            if (otherWeightField_ == nil) {
                tf = otherWeightField_ = [self makeTextField:self.otherWeight placeholder:@"10 %"];
            }
            [cell addSubview:otherWeightField_];
            break;
        case 6:
            [cell.textLabel setText:@"Final Exam Weight"];
            if (finalExamWeightField_ == nil) {
                tf = finalExamWeightField_ = [self makeTextField:self.finalExamWeight placeholder:@"10 %"];
            }
            [cell addSubview:finalExamWeightField_];
            break;
        case 7:
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7) {
        [self formSubmit];
    }
}

-(void) formSubmit
{
    //Dismiss Keyboard when this button is pressed:
    [self.view endEditing:YES];
    
     bool checker = YES;
    //Make sure the user didn't enter any empty strings:
    NSMutableString *errorString = [[NSMutableString alloc] init];
    
    if (self.attendanceWeight == nil || self.essayWeight == nil || self.quizWeight == nil || self.testWeight == nil || self.finalExamWeight == nil || self.otherWeight == nil || self.hwWeight == nil || [self.attendanceWeight isEqualToString:@""] || [self.essayWeight isEqualToString:@""] || [self.quizWeight isEqualToString:@""] || [self.testWeight isEqualToString:@""] || [self.hwWeight isEqualToString:@""] || [self.otherWeight isEqualToString:@""] || [self.finalExamWeight isEqualToString:@""]) {
        
        checker = NO;
        [errorString appendString:@"Sorry, but please enter a zero if you do not have a value for a category."];
    }
    
    //Make sure the user has entered weights that add up to 100:
    
    if (checker == YES) {
        int sum = [self.attendanceWeight intValue] + [self.essayWeight intValue] + [self.quizWeight intValue] + [self.testWeight intValue] + [self.hwWeight intValue] + [self.otherWeight intValue] + [self.finalExamWeight intValue];
        if (sum != 100) {
            [errorString appendString:@"Sorry, but course weights must add up to 100 %."];
            checker = NO;
        }
    
    }
    
    if (checker == YES) {
       //Find the course object and update its weight values:
        //Pull the course object with this title out of memory:
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
        
        [request setEntity:entity];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.courseTitle like %@",self.title];
        
        [request setPredicate:predicate];
        NSError *error;
        NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (array != nil) {
            //there should only be one object:
            [[array objectAtIndex:0] setHomeworkWeight:[NSString stringWithFormat:@"%@", self.hwWeight]];
            [[array objectAtIndex:0] setAtendanceWeight:[NSString stringWithFormat:@"%@", self.attendanceWeight]];
            [[array objectAtIndex:0] setEssayWeight:[NSString stringWithFormat:@"%@", self.essayWeight]];
            [[array objectAtIndex:0] setQuizWeight:[NSString stringWithFormat:@"%@", self.quizWeight]];
            [[array objectAtIndex:0] setTestWeight:[NSString stringWithFormat:@"%@", self.testWeight]];
            [[array objectAtIndex:0] setOtherWeight:[NSString stringWithFormat:@"%@", self.otherWeight]];
            [[array objectAtIndex:0] setFinalWeight:[NSString stringWithFormat:@"%@", self.finalExamWeight]];
            [self.managedObjectContext save:&error];
        }
        
        [[self.navigationController.viewControllers objectAtIndex:2]
         reloadGradesData];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else{
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", errorString] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
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
    
	if ( textField == hwWeightField_) {
		self.hwWeight = textField.text ;
	}
    else if (textField == quizWeightField_){
        self.quizWeight = textField.text;
    }
    else if (textField == testWeightField_){
        self.testWeight = textField.text;
    }
    else if (textField == essayWeightField_){
        self.essayWeight = textField.text;
    }
    else if (textField == attendanceWeightField_){
        self.attendanceWeight = textField.text;
    }
    else if (textField == otherWeightField_){
        self.otherWeight = textField.text;
    }
    else if (textField == finalExamWeightField_){
        self.finalExamWeight = textField.text;
    }
}

//This method ensures the user can't enter any illegal characters (#defined at the top)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    
    NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLEWEIGHTCHARACTERS];
    NSInteger maxLength = 3;
    NSInteger maxStringLength = [textField.text length] + [replacementString length] -range.length;
    if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxStringLength >= maxLength) {
        return NO;
    }
    else{
        return YES;
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
