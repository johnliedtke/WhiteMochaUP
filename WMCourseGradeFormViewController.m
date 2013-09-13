//
//  WMCourseGradeFormViewController.m
//  ParseStarterProject
//
//  Created by Derek Schumacher on 7/31/13.
//
//

#import "WMCourseGradeFormViewController.h"

#define ACCEPTABLESCORE_CHARACTERS @"0123456789."
#define ACCEPTABLEMAXPOINTS_CHARACTERS @"0123456789."
#define ACCEPTABLEASSIGNMENTNAME_CHARACTERS @" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
@interface WMCourseGradeFormViewController ()

@end

@implementation WMCourseGradeFormViewController
@synthesize score = score_;

@synthesize managedObjectContext;
-(void) sendCourseTitle:(NSString *)courseTitle
{
    self.courseTitle = courseTitle;
}


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
    
    NSString *formType = self.gradeType;
    [self setTitle:[NSString stringWithFormat:@"%@ %@ score",self.courseTitle,formType]];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    UITextField *tf = nil;
    
    if (indexPath.section == 0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        if (scoreField_ == nil) {
            tf = scoreField_ = [self makeTextField:self.score placeholder:@"70.00"];
        }
        [scoreField_ setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:scoreField_];
        [cell.textLabel setText:@"Your Score:"];
    }
    
    if (indexPath.section == 2){
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        if (assignmentNameField_ == nil) {
            tf = assignmentNameField_ = [self makeTextField:self.assignmentName placeholder:@"Reading"];
        }
        [assignmentNameField_ setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:assignmentNameField_];
        
        NSString *assignmentName = self.gradeType;
        [cell.textLabel setText:[NSString stringWithFormat:@"%@ Title:",assignmentName]];
        
    }
    if (indexPath.section == 1){
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        if (maxPointsField_ == nil) {
            tf = maxPointsField_ = [self makeTextField:self.maxPoints placeholder:@"100"];
        }
        [maxPointsField_ setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:maxPointsField_];
        [cell.textLabel setText:@"Points Possible:"];
        
    }
    if (indexPath.section == 3){
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setText:@"Submit"];
    }
    
    tf.frame = CGRectMake(160, 12, 170, 30);
    [tf addTarget:self action:@selector(textFieldFinished:)
 forControlEvents:UIControlEventEditingDidEndOnExit];
    tf.delegate = self ;
    // Configure the cell...
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Send the grade to the gradeSheet:
    
    //Send the user back to the grade view screen:
    //WMCourseDetailController * controller = [[WMCourseDetailController alloc] init];
    if (indexPath.section == 3) {
        /*
         //Add a grade object to parse: Consider switching to core data
         PFObject *object = [PFObject objectWithClassName:@"Grade"];
         [object setObject:self.courseTitle forKey:@"CourseTitle"];
         [object setObject:self.gradeType forKey:@"GradeType"];
         [object setObject:self.score forKey:@"CourseScore"];
         [object setObject:self.maxPoints forKey:@"MaxPoints"];
         [object saveInBackground];
         */
        //Use Core data to save the object:
        [self.view endEditing:YES];
        if (self.courseTitle && self.gradeType && self.score && self.maxPoints && self.assignmentName && ![self.courseTitle isEqualToString:@""] && ![self.gradeType isEqualToString:@""] && ![self.score isEqualToString:@""] && ![self.maxPoints isEqualToString:@""] && ![self.assignmentName isEqualToString:@""]){
            //Check to see if the assignment name is unique:
            //Pull the info off the core:
            NSManagedObjectContext *context = [self managedObjectContext];
            NSError *error;
            NSFetchRequest *request= [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Grade" inManagedObjectContext:context];
            [request setEntity:entity];
            NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
            BOOL checker = YES;
            for (Grade *grades in fetchedObjects) {
                if ([grades.assignmentName isEqualToString: self.assignmentName]) {
                    checker = NO;
                }
            }
            if (checker == YES) {
                NSManagedObjectContext *context = [self managedObjectContext];
                Grade *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Grade" inManagedObjectContext:context];
                newObject.courseTitle = self.courseTitle;
                newObject.gradeType = self.gradeType;
                newObject.courseScore = self.score;
                newObject.maxPoints = self.maxPoints;
                newObject.assignmentName = self.assignmentName;
                
                NSError *error;
                if (![context save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                    UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Error :(" message:@"Something went wrong with saving the data. Please try again. If problem persists, contact app creators." delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
                    [failure show];
                }
                [self.managedObjectContext save:&error];
                //Test list all info from store:
                /*
                 NSFetchRequest *request= [[NSFetchRequest alloc] init];
                 NSEntityDescription *entity = [NSEntityDescription entityForName:@"Grade" inManagedObjectContext:context];
                 [request setEntity:entity];
                 NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
                 for (Grade *grades in fetchedObjects) {
                 NSLog(@"Name: %@", grades.courseTitle);
                 
                 }
                 */
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success!" message:[NSString stringWithFormat:@"Grade was successfully added to course: %@.", self.courseTitle] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
                [success show];
            }
            else{
                NSMutableString *errorString =[[NSMutableString alloc] init];
                if (!self.courseTitle || [self.courseTitle isEqualToString: @""]) {
                    [errorString appendString:@"Course Title\n"];
                }
                if (!self.score || [self.score isEqualToString:@""]) {
                    [errorString appendString:@"Score\n"];
                }
                if (!self.maxPoints || [self.maxPoints isEqualToString:@""]) {
                    [errorString appendString:@"Max Points\n"];
                }
                if (!self.assignmentName || [self.assignmentName isEqualToString:@""]) {
                    [errorString appendString:@"Assignment Name\n"];
                }
                if (!self.maxPoints || [self.maxPoints isEqualToString:@""]) {
                    [errorString appendString:@"Max Points\n"];
                }
                if (checker == NO) {
                    [errorString appendString: @"Unique Assignment name\n"];
                }
                UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Missing the Following: \n%@", errorString ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [errorMessage show];
                }
            }
        else{
            NSMutableString *errorString =[[NSMutableString alloc] init];
            if (!self.courseTitle || [self.courseTitle isEqualToString: @""]) {
                [errorString appendString:@"Course Title\n"];
            }
            if (!self.score || [self.score isEqualToString:@""]) {
                [errorString appendString:@"Score\n"];
            }
            if (!self.maxPoints || [self.maxPoints isEqualToString:@""]) {
                [errorString appendString:@"Max Points\n"];
            }
            if (!self.assignmentName || [self.assignmentName isEqualToString:@""]) {
                [errorString appendString:@"Assignment Name\n"];
            }
            if (!self.maxPoints || [self.maxPoints isEqualToString:@""]) {
                [errorString appendString:@"Max Points\n"];
            }
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Missing the Following: \n%@", errorString ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [errorMessage show];

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
    if (textField == scoreField_) {
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLESCORE_CHARACTERS];
        NSInteger maxLength = 6;
        NSInteger maxProfNameLength = [textField.text length] + [replacementString length] -range.length;
        if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxProfNameLength >= maxLength) {
            return NO;
            
        }
        else{
            return YES;
        }
        
    }
    if (textField == maxPointsField_) {
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLEMAXPOINTS_CHARACTERS];
        NSInteger maxLength = 5;
        NSInteger maxProfNameLength = [textField.text length] + [replacementString length] -range.length;
        if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxProfNameLength >= maxLength) {
            return NO;
            
        }
        else{
            return YES;
        }
    }
    
    if (textField == assignmentNameField_) {
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLEASSIGNMENTNAME_CHARACTERS];
        NSInteger maxLength = 15;
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
	tf.placeholder = placeholder;
	tf.text = text;
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
	tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
	return tf;
}
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}
// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //************************* Insert Error Checking *************************************************
	if ( textField == scoreField_ ) {
		self.score = textField.text ;
	}
    else if (textField == maxPointsField_){
        self.maxPoints = textField.text;
    }
    else if (textField == assignmentNameField_){
        self.assignmentName = textField.text;
    }
}

@end
