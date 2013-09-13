//
//  WMCourseTrackGradeViewController.m
//  ParseStarterProject
//
//  Created by Derek Schumacher on 7/28/13.
//
//

#import "WMCourseTrackGradeViewController.h"


#define ACCEPTABLE_CHARACTERS @"0123456789"

@interface WMCourseTrackGradeViewController ()

@end

@implementation WMCourseTrackGradeViewController
@synthesize quizWeight = quizWeight_;
@synthesize testWeight = testWeight_;
@synthesize essayWeight = essayWeight_;
@synthesize homeWorkWeight = homeWorkWeight_;
@synthesize attendanceWeight = attendanceWeight_;
@synthesize finalExamWeight = finalExamWeight_;
@synthesize otherWeight = otherWeight_;




-(void) sendCourseName:(NSString *)courseName{
    [self setCourseTitle:courseName];
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
    NSString *meow = self.courseTitle;
    [self setTitle: [NSString stringWithFormat:@"Track %@ Grade", meow]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"WMPrevNext" owner:self options:nil];
    prevNext = [subviewArray objectAtIndex:0];
    [prevNext setPrevNextDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PrevNext
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [prevNext setUp:textField];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [prevNext setFields:[[NSMutableArray alloc] initWithObjects:quizWeightField_,testWeightField_,essayWeightField_,homeWorkWeightField_,attendanceWeightField_,finalExamWeightField_,otherWeightField_, nil]];
    if ([indexPath section] == 0 && [indexPath row] == [prevNext currentIndex]-1) {
        [[[cell subviews] objectAtIndex:0] becomeFirstResponder];
        NSLog(@"meow");
    }
}
- (void)donePressed
{
    [self hideKeyboard];
}

-(void)hideKeyboard
{
    [[self view] endEditing:YES];
}

-(void)prevNextPressed:(UITextField *)textField
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:[prevNext currentIndex] inSection:0];
    [[self tableView] scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle
                                    animated:YES];
    [textField becomeFirstResponder];
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
        return 7;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableCell"];
    }
    
    //Configure the Cell:
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField *tf = nil;
    if(indexPath.section == 0)
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Quiz Weight";
                if (quizWeightField_ == nil) {
                    tf = quizWeightField_ = [self makeTextField:self.quizWeight placeholder:@"10 %"];
                }
                [quizWeightField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:quizWeightField_];
                break;
            case 1:
                cell.textLabel.text = @"Test Weight";
                if (testWeightField_ == nil) {
                    tf = testWeightField_ = [self makeTextField:self.testWeight placeholder:@"30 %"];
                }
                [testWeightField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:testWeightField_];
                break;
            case 2:
                cell.textLabel.text = @"Essay Weight";
                if (essayWeightField_ == nil){
                    tf = essayWeightField_ = [self makeTextField:self.essayWeight placeholder:@"20 %"];
                }
                [essayWeightField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:essayWeightField_];
                break;
            case 3:
                cell.textLabel.text = @"HW Weight";
                if (homeWorkWeightField_ == nil){
                    tf = homeWorkWeightField_ = [self makeTextField:self.homeWorkWeight placeholder:@"10 %"];
                }
                [homeWorkWeightField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:homeWorkWeightField_];
                break;
            case 4:
                cell.textLabel.text = @"Atten/Part Weight";
                if (attendanceWeightField_ == nil) {
                    tf = attendanceWeightField_ = [self makeTextField:self.attendanceWeight placeholder:@"10 %"];
                }
                [attendanceWeightField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:attendanceWeightField_];
                break;
            case 5:
                cell.textLabel.text = @"Final Exam Weight";
                if (finalExamWeight_ == nil) {
                    tf = finalExamWeightField_ = [self makeTextField:self.finalExamWeight placeholder:@"30 %"];

                }
                [finalExamWeightField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:finalExamWeightField_];
                break;
            case 6:
                cell.textLabel.text = @"Other Weight";
                if (otherWeightField_ == nil) {
                    tf = otherWeightField_ = [self makeTextField:self.otherWeight placeholder:@"0 %"];

                }
                [otherWeightField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:otherWeightField_];
                break;
            default:
                break;
        }
    
    tf.frame = CGRectMake(160, 12, 170, 30);
    [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    tf.delegate = self ;
    /*
     if (indexPath.section == 1) {
     cell.selectionStyle = UITableViewCellSelectionStyleBlue;
     [cell.textLabel setTextAlignment:UITextAlignmentCenter];
     cell.textLabel.text = @"Enter Grades";
     }
     */
    if (indexPath.section == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        cell.textLabel.text = @"Submit";
    }
    
    
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
    
    if(indexPath.section == 1){
        [self.view endEditing:YES];
        if (self.quizWeight && self.essayWeight && self.testWeight && self.homeWorkWeight && ![self.quizWeight isEqualToString:@""] && ![self.essayWeight isEqualToString:@""] && ![self.testWeight isEqualToString:@""] && ![self.homeWorkWeight isEqualToString:@""] && ![self.attendanceWeight isEqualToString:@""] && self.attendanceWeight && self.otherWeight && ![self.otherWeight isEqualToString:@""] && self.finalExamWeight && ![self.finalExamWeight isEqualToString:@""]) {
            
            
            //Dismiss the keyboard:
            [self.view endEditing:YES];
            
            NSString *quizWeight = self.quizWeight;
            NSString *essayWeight = self.essayWeight;
            NSString *testWeight = self.testWeight;
            NSString *homeworkWeight= self.homeWorkWeight;
            NSString *attendanceWeight = self.attendanceWeight;
            NSString *otherWeight = self.otherWeight;
            NSString *finalWeight = self.finalExamWeight;
            
            //Save the weights on the Core:
            //Update the object on the Core:
            NSManagedObjectContext *context = [self managedObjectContext];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity =
            [NSEntityDescription entityForName:@"Course"
                        inManagedObjectContext:self.managedObjectContext];
            [request setEntity:entity];
            
            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"self.courseTitle like %@", self.courseTitle];
            [request setPredicate:predicate];
            
            NSError *error;
            NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
            if (array != nil) {
               // NSUInteger count = [array count]; // May be 0 if the object has been deleted.
                //
            }
            else {
                // Deal with error.
            }
            Course *course = [array objectAtIndex:0];
            [course setQuizWeight:quizWeight];
            [course setEssayWeight:essayWeight];
            [course setTestWeight:testWeight];
            [course setHomeworkWeight:homeworkWeight];
            [course setAttendanceWeight:attendanceWeight];
            [course setOtherWeight:otherWeight];
            [course setFinalExamWeight:finalWeight];
            
            
            //NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            [self.managedObjectContext save:&error];
            
            
            
            
            /*
            PFQuery *query = [PFQuery queryWithClassName:@"Course"];
            NSString *courseName = self.courseTitle;
            [query whereKey:@"CourseTitle" equalTo:courseName];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved %d scores.", objects.count);
                    // Do something with the found objects
                    for (PFObject *object in objects) {
                        PFObject *foundObject = [PFObject objectWithClassName:@"Course"];
                        foundObject = [objects objectAtIndex:0];
                        [foundObject setObject:quizWeight forKey:@"QuizWeight"];
                        [foundObject setObject:essayWeight forKey:@"EssayWeight"];
                        [foundObject setObject:testWeight forKey:@"TestWeight"];
                        [foundObject setObject:homeworkWeight forKey:@"HomeworkWeight"];
                        [foundObject setObject:attendanceWeight forKey:@"AttendanceWeight"];
                        [foundObject setObject:otherWeight forKey:@"OtherWeight"];
                        [foundObject setObject:finalWeight forKey:@"FinalExamWeight"];
                        [foundObject saveInBackground];
                        NSLog(@"%@", object.objectId);
                    }
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
            */
            //Final Check to see if the weights add up to 100:
            if (([self.quizWeight doubleValue] + [self.attendanceWeight doubleValue] + [self.homeWorkWeight doubleValue] + [self.otherWeight doubleValue] + [self.testWeight doubleValue] + [self.essayWeight doubleValue] + [self.finalExamWeight doubleValue]) <= 100) {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                UIAlertView *done = [[UIAlertView alloc] initWithTitle:@"Success" message: [NSString stringWithFormat:@"Grade Weights for %@ Updated!", self.courseTitle] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
                [done show];
                
            }
            
            else{
                UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Course Weights need to add up to less than 100 %" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [error show];
            }
            
            
        
        }
        else{
            NSMutableString *errorString = [[NSMutableString alloc] init];
            if (! self.quizWeight || [self.quizWeight isEqualToString:@""]) {
                [errorString appendString:@"Quiz Weight "];
            }
            if (! self.testWeight || [self.quizWeight isEqualToString:@""]) {
                [errorString appendString:@"Test Weight "];
            }
            if (! self.essayWeight || [self.essayWeight isEqualToString:@""]) {
                [errorString appendString:@"Essay Weight "];
            }
            if (! self.homeWorkWeight || [self.homeWorkWeight isEqualToString:@""]) {
                [errorString appendString:@"Homework Weight "];
            }
            if (! self.otherWeight || [self.otherWeight isEqualToString:@""]) {
                [errorString appendString:@"Other Weight "];
            }
            if (! self.finalExamWeight || [self.finalExamWeight isEqualToString:@""]) {
                [errorString appendString:@"Final Weight "];
            }
            if (! self.attendanceWeight || [self.attendanceWeight isEqualToString:@""]) {
                [errorString appendString:@"Attendance Weight "];
            }
        
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Please enter the following: %@. If you don't want to enter the weight at this time, enter a 0 for that field", errorString] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [errorAlert show];
        }
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
    [tf setInputAccessoryView:prevNext];
    [tf setKeyboardType:UIKeyboardTypeDecimalPad];
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
	if ( textField == quizWeightField_ ) {
		self.quizWeight = textField.text ;
    }
    else if ( textField == homeWorkWeightField_ )
    {
        self.homeWorkWeight = textField.text ;
    }
    else if ( textField == essayWeightField_ )
    {
        self.essayWeight = textField.text ;
    }
    else if ( textField == testWeightField_ )
    {
        self.testWeight = textField.text ;
    }
    else if ( textField == attendanceWeightField_ )
    {
        self.attendanceWeight = textField.text;
    }
    else if ( textField == otherWeightField_ )
    {
        self.otherWeight = textField.text;
    }
    else if ( textField == finalExamWeightField_ ){
        self.finalExamWeight = textField.text;
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
    //if (textField == profNameField_) {
        NSCharacterSet *acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS];
        NSInteger maxLength = 3;
        NSInteger maxProfNameLength = [textField.text length] + [replacementString length] -range.length;
        if ([replacementString rangeOfCharacterFromSet:[acceptableCharacters invertedSet]].location != NSNotFound || maxProfNameLength >= maxLength) {
            return NO;
            
        }
        else{
            return YES;
        }
        
    //}
}

@end
