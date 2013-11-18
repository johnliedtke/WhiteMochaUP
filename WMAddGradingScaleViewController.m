//
//  WMAddGradingScaleViewController.m
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 11/16/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import "WMAddGradingScaleViewController.h"
#define ACCEPTABLECHARACTERS @"123456789 0"

@interface WMAddGradingScaleViewController ()

@end

@implementation WMAddGradingScaleViewController

@synthesize aValue = aValue_;
@synthesize aMinusValue = aMinusValue_;
@synthesize bPlusValue = bPlusValue_;
@synthesize bValue = bValue_;
@synthesize bMinusValue = bMinusValue_;
@synthesize cPlusValue = cPlusValue_;
@synthesize cValue = cValue_;
@synthesize cMinusValue = cMinusValue_;
@synthesize dPlusValue = dPlusValue_;
@synthesize dValue = dValue_;
@synthesize dMinusValue = dMinusValue_;



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
    return 12;
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
            [cell.textLabel setText:@"Minimum A Value:"];
            if (aValueField_ == nil) {
                tf = aValueField_ = [self makeTextField:self.aValue placeholder:@"92 %"];
            }
            [cell addSubview:aValueField_];
            break;
        case 1:
            [cell.textLabel setText:@"Minimum A- Value:"];
            if (aMinusField_ == nil) {
                tf = aMinusField_ = [self makeTextField:self.aMinusValue placeholder:@"90 %"];
            }
            [cell addSubview:aMinusField_];
            break;
        case 2:
            [cell.textLabel setText:@"Minimum B+ Value:"];
            if (bPlusField_ == nil) {
                tf = bPlusField_ = [self makeTextField:self.bPlusValue placeholder:@"85 %"];
            }
            [cell addSubview:bPlusField_];
            break;
        case 3:
            [cell.textLabel setText:@"Minimum B Value:"];
            if (bField_ == nil) {
                tf = bField_ = [self makeTextField:self.bValue placeholder:@"82 %"];
            }
            [cell addSubview:bField_];
            break;
        case 4:
            [cell.textLabel setText:@"Minimum B- Value:"];
            if (bMinusField_ == nil) {
                tf = bMinusField_ = [self makeTextField:self.bMinusValue placeholder:@"80 %"];
            }
            [cell addSubview:bMinusField_];
            break;
        case 5:
            [cell.textLabel setText:@"Minimum C+ Value:"];
            if (cPlusField_ == nil) {
                tf = cPlusField_ = [self makeTextField:self.cPlusValue placeholder:@"77 %"];
            }
            [cell addSubview:cPlusField_];
            break;
        case 6:
            [cell.textLabel setText:@"Minimum C Value:"];
            if (cField_ == nil) {
                tf = cField_ = [self makeTextField:self.cValue placeholder:@"72 %"];
            }
            [cell addSubview:cField_];
            break;
        case 7:
            [cell.textLabel setText:@"Minimum C- Value:"];
            if (cMinusField_ == nil) {
                tf = cMinusField_ = [self makeTextField:self.cMinusValue placeholder:@"70 %"];
            }
            [cell addSubview:cMinusField_];
            break;
        case 8:
            [cell.textLabel setText:@"Minimum D+ Value:"];
            if (dPlusField_ == nil) {
                tf = dPlusField_ = [self makeTextField:self.dPlusValue placeholder:@"67 %"];
            }
            [cell addSubview:dPlusField_];
            break;
        case 9:
            [cell.textLabel setText:@"Minimum D Value:"];
            if (dField_ == nil) {
                tf = dField_ = [self makeTextField:self.dValue placeholder:@"65 %"];
            }
            [cell addSubview:dField_];
            break;
        case 10:
            [cell.textLabel setText:@"Minimum D- Value:"];
            if (dMinusField_ == nil) {
                tf = dMinusField_ = [self makeTextField:self.dMinusValue placeholder:@"60 %"];
            }
            [cell addSubview:dMinusField_];
            break;
        case 11:
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

//This method is called when a section (indexPath.row) is clicked on by the user:
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 11) {
        //Dismiss the keyboard when this button is pressed:
        [self.view endEditing:YES];
        BOOL checker = YES;
        NSMutableString *errorMessage = [[NSMutableString alloc] init];
        
        if ([self.aValue isEqualToString:@""] || [self.dValue isEqualToString:@""] || [self.cPlusValue isEqualToString:@""] || self.aValue == nil || self.dValue == nil || self.cPlusValue == nil)  {
            checker = NO;
            [errorMessage appendString:@"Please fill out form completely."];
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
                    if([courses.courseTitle isEqualToString:[NSString stringWithFormat:@"%@", self.courseTitle]]){
                        
                        [courses setAValue:self.aValue];
                        [courses setAMinusValue:self.aMinusValue];
                        [courses setBPlusValue:self.bPlusValue];
                        [courses setBValue:self.bValue];
                        [courses setBMinusValue:self.bMinusValue];
                        [courses setCPlusValue:self.cPlusValue];
                        [courses setCValue:self.cValue];
                        [courses setCMinusValue:self.cMinusValue];
                        [courses setDPlusValue:self.dPlusValue];
                        [courses setDValue:self.dValue];
                        [courses setDMinusValue:self.dMinusValue];
                    }
                }
                
            }
            
            //Save
            [self.managedObjectContext save:&error];
        }
        if (checker == YES) {
            
            //Send a reload message:
            [[self.navigationController.viewControllers objectAtIndex:2]
             reloadGradesData];
            
            //Go back a view controller:
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            //Print out an error message:
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Could not Submit." message: errorMessage delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [error show];
        }

    }
}

//This method ensures the user can't enter any illegal characters (#defined at the top)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLECHARACTERS];
        NSInteger maxLength = 3;
        NSInteger maxStringLength = [textField.text length] + [replacementString length] -range.length;
        if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxStringLength >= maxLength) {
            return NO;
        }
        else{
            return YES;
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
    
	if ( textField == aValueField_) {
		self.aValue = textField.text ;
	}
    else if (textField == aMinusField_){
        self.aMinusValue = textField.text;
    }
    else if (textField == bPlusField_){
        self.bPlusValue = textField.text;
    }
    else if (textField == bField_){
        self.bValue = textField.text;
    }
    else if (textField == bMinusField_){
        self.bMinusValue = textField.text;
    }
    else if (textField == cPlusField_){
        self.cPlusValue = textField.text;
    }
    else if (textField == cField_){
        self.cValue = textField.text;
    }
    else if (textField == cMinusField_){
        self.cMinusValue = textField.text;
    }
    else if (textField == dPlusField_){
        self.dPlusValue = textField.text;
    }
    else if (textField == dField_){
        self.dValue = textField.text;
    }
    else if (textField == dMinusField_){
        self.dMinusValue = textField.text;
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
