//
//  WMCourseChangeGradingScaleViewController.m
//  ParseStarterProject
//
//  Created by Derek Schumacher on 8/17/13.
//
//

#import "WMCourseChangeGradingScaleViewController.h"
#define ACCEPTABLE_CHARACTERS @"0123456789"

@interface WMCourseChangeGradingScaleViewController ()

@end

@implementation WMCourseChangeGradingScaleViewController

@synthesize AValue = AValue_;
@synthesize AMinusValue = AMinusValue_;
@synthesize BPlusValue = BPlusValue_;
@synthesize BValue = BValue_;
@synthesize BMinusValue = BMinusValue_;
@synthesize CPlusValue = CPlusValue_;
@synthesize CValue = CValue_;
@synthesize CMinusValue = CMinusValue_;
@synthesize DPlusValue = DPlusValue_;
@synthesize DValue = DValue_;
@synthesize DMinusValue = DMinusValue_;
//@synthesize FValue = FValue_;

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

    // Prev Next
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"WMPrevNext" owner:self options:nil];
    prevNext = [subviewArray objectAtIndex:0];
    [prevNext setPrevNextDelegate:self];
}

#pragma mark - PrevNext
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [prevNext setUp:textField];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [prevNext setFields:[[NSMutableArray alloc] initWithObjects:AValueField_,AMinusValueField_,BPlusValueField_,BValueField_,BMinusValueField_,CPlusValueField_,CValueField_,CMinusValueField_,DPlusValueField_,DValueField_,DMinusValueField_, nil]];
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
    if (section == 0) {
        return 11;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }

    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField *tf = nil;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Minimum A Value";
                if (AValueField_ == nil) {
                    tf = AValueField_ = [self makeTextField:self.AValue placeholder:@"93 %"];
                }
                
                [AValueField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:AValueField_];
                break;
            case 1:
                cell.textLabel.text = @"Minimum A- Value";
                if (AMinusValueField_ == nil){
                    tf = AMinusValueField_ = [self makeTextField:self.AMinusValue placeholder:@"90 %"];
                }
                [AMinusValueField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:AMinusValueField_];
                break;
            case 2:
                cell.textLabel.text = @"Minimum B+ Value";
                if (BPlusValueField_ == nil){
                    tf = BPlusValueField_ = [self makeTextField:self.BPlusValue placeholder:@"87 %"];
                }
                [BPlusValueField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:BPlusValueField_];
                break;
            case 3:
                cell.textLabel.text = @"Minimum B Value";
                if (BValueField_ == nil){
                    tf = BValueField_ = [self makeTextField:self.BValue placeholder:@"83 %"];
                }
                [BValueField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:BValueField_];
                break;
            case 4:
                cell.textLabel.text = @"Minimum B- Value";
                if (BMinusValueField_ == nil){
                    tf = BMinusValueField_ = [self makeTextField:self.BMinusValue placeholder:@"80 %"];
                }
                [BMinusValueField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:BMinusValueField_];
                break;
            case 5:
                cell.textLabel.text = @"Minimum C+ Value";
                if (CPlusValueField_ == nil){
                    tf = CPlusValueField_ = [self makeTextField:self.CPlusValue placeholder:@"77 %"];
                }
                [CPlusValueField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:CPlusValueField_];
                break;
            case 6:
                cell.textLabel.text = @"Minimum C Value";
                if (CValueField_ == nil){
                    tf = CValueField_ = [self makeTextField:self.CValue placeholder:@"73 %"];
                }
                [CValueField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:CValueField_];
                break;
            case 7:
                cell.textLabel.text = @"Minimum C- Value";
                if (CMinusValueField_ == nil){
                    tf = CMinusValueField_ = [self makeTextField:self.CMinusValue placeholder:@"70 %"];
                }
                [CMinusValueField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:CMinusValueField_];
                break;
            case 8:
                cell.textLabel.text = @"Minimum D+ Value";
                if (DPlusValueField_ == nil){
                    tf = DPlusValueField_ = [self makeTextField:self.DPlusValue placeholder:@"67 %"];
                }
                [DPlusValueField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:DPlusValueField_];
                break;
            case 9:
                cell.textLabel.text = @"Minimum D Value";
                if (DValueField_ == nil){
                    tf = DValueField_ = [self makeTextField:self.DValue placeholder:@"63 %"];
                }
                [DValueField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:DValueField_];
                break;
            case 10:
                cell.textLabel.text = @"Minimum D- Value";
                if (DMinusValueField_ == nil){
                    tf = DMinusValueField_ = [self makeTextField:self.DMinusValue placeholder:@"60 %"];
                }
                [DMinusValueField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:DMinusValueField_];
                break;
                /*
            case 11:
                cell.textLabel.text = @"Maximum F Value";
                tf = FValueField_ = [self makeTextField:self.FValue placeholder:@"60 %"];
                [FValueField_ setTextAlignment:NSTextAlignmentCenter];
                [cell addSubview:FValueField_];
                break;
                 */
            default:
                break;
        }
    }
    tf.frame = CGRectMake(160, 12, 170, 30);
    [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    tf.delegate = self ;
    
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
    //If the submit button is pressed:
    if (indexPath.section == 1) {
        
        //Dismiss the keyboard:
        [self.view endEditing:YES];
        
        
        NSString *aValue = self.AValue;
        NSString *aMinusValue = self.AMinusValue;
        NSString *bPlusValue = self.BPlusValue;
        NSString *bValue = self.BValue;
        NSString *bMiniusValue = self.BMinusValue;
        NSString *cPlusValue = self.CPlusValue;
        NSString *cValue = self.CValue;
        NSString *cMinusValue = self.CMinusValue;
        NSString *dPlusValue = self.DPlusValue;
        NSString *dValue = self.DValue;
        NSString *dMinusValue = self.DMinusValue;
        //NSString *FValue = self.FValue;
        
        //Save the values to the core:
        //Find the course object, then update it:
        if (aValue && ![aValue isEqualToString:@""] && aMinusValue && ![aMinusValue isEqualToString:@""] && bPlusValue && ![bPlusValue isEqualToString:@""] && bValue && ![bValue isEqualToString:@""] && bMiniusValue && ![bMiniusValue isEqualToString:@""] && cPlusValue && ![cPlusValue isEqualToString:@""] && cValue && ![cValue isEqualToString:@""] && cMinusValue && ![cMinusValue isEqualToString:@""] && dPlusValue && ![dPlusValue isEqualToString:@""]&& dValue && ![dValue isEqualToString:@""] && dMinusValue && ![dMinusValue isEqualToString:@""] /*&& FValue && ![FValue isEqualToString:@""]*/) {
            
            
            //Find the course objects:
            //Pull the info off the core:
            NSManagedObjectContext *context = [self managedObjectContext];
            NSError *error;
            NSFetchRequest *request= [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
            [request setEntity:entity];
            NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
            int index = 0;
            Course *course;
            for (Course *courses in fetchedObjects) {
                //Find the right course:
                if ([courses.courseTitle isEqualToString:self.courseTitle]) {
                    course = [fetchedObjects objectAtIndex:index];
                }
                index++;
            }
            
            //We have now found the course object, update it to include the custom grade scale:
            course.aValue = self.AValue;
            course.aMinusValue = self.AMinusValue;
            course.bPlusValue = self.BPlusValue;
            course.bValue = self.BValue;
            course.bMinusValue = self.BMinusValue;
            course.cPlusValue = self.CPlusValue;
            course.cValue = self.CValue;
            course.cMinusValue = self.CMinusValue;
            course.dPlusValue = self.DPlusValue;
            course.dValue = self.DValue;
            course.dMinusValue = self.DMinusValue;
            course.fValue = self.DMinusValue;
            
            UIAlertView *successMessage = [[UIAlertView alloc] initWithTitle:@"Success!" message:[NSString stringWithFormat:@"Successfully added the custom grading scale to %@", self.courseTitle] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [successMessage show];
        }
        else{
            NSMutableString *errorMessageString = [[NSMutableString alloc] init];
            if (!self.AValue || [self.AValue isEqualToString:@""]) {
                [errorMessageString appendString:@"A Value\n"];
            }
            if (!self.AMinusValue || [self.AMinusValue isEqualToString:@""]) {
                [errorMessageString appendString:@"A- Value\n"];
            }
            if (!self.BPlusValue || [self.BPlusValue isEqualToString:@""]) {
                [errorMessageString appendString:@"B+ Value\n"];
            }
            if (!self.BValue || [self.BValue isEqualToString:@""]) {
                [errorMessageString appendString:@"B Value\n"];
            }
            if (!self.BMinusValue || [self.BMinusValue isEqualToString:@""]) {
                [errorMessageString appendString: @"B- Value\n"];
            }
            if (!self.CPlusValue || [self.CPlusValue isEqualToString:@""]) {
                [errorMessageString appendString:@"C+ Value\n"];
            }
            if (!self.CValue || [self.CValue isEqualToString:@""]) {
                [errorMessageString appendString:@"C Value\n"];
            }
            if (!self.CMinusValue || [self.CMinusValue isEqualToString:@""]) {
                [errorMessageString appendString:@"C- Value\n"];
            }
            if (!self.DPlusValue || [self.DPlusValue isEqualToString:@""]) {
                [errorMessageString appendString:@"D+ Value\n"];
            }
            if (!self.DValue || [self.DValue isEqualToString:@""]) {
                [errorMessageString appendString:@"D Value\n"];
            }
            if (!self.DMinusValue || [self.DMinusValue isEqualToString:@""]) {
                [errorMessageString appendString:@"D- Value\n"];
            }
            //if (!self.FValue || [self.FValue isEqualToString:@""]) {
              //  [errorMessageString appendString:@"F Value \n"];
            //}
            
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Missing: %@ \n", errorMessageString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorMessage show];
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
    [tf setDelegate:self];
	return tf ;
}
// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //************************* Insert Error Checking *************************************************
	if ( textField == AValueField_ ) {
		self.AValue = textField.text ;
    }
    else if ( textField == AMinusValueField_){
        self.AMinusValue = textField.text;
    }
    else if (textField == BPlusValueField_){
        self.BPlusValue = textField.text;
    }
    else if (textField == BValueField_){
        self.BValue = textField.text;
    }
    else if (textField == BMinusValueField_){
        self.BMinusValue = textField.text;
    }
    else if (textField == CPlusValueField_){
        self.CPlusValue = textField.text;
    }
    else if (textField == CValueField_){
        self.CValue = textField.text;
    }
    else if (textField == CMinusValueField_){
        self.CMinusValue = textField.text;
    }
    else if (textField == DPlusValueField_){
        self.DPlusValue = textField.text;
    }
    else if (textField == DValueField_){
        self.DValue = textField.text;
    }
    else if (textField == DMinusValueField_){
        self.DMinusValue = textField.text;
    }
    //else if (textField == FValueField_){
      //  self.FValue = textField.text;
    //}

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
