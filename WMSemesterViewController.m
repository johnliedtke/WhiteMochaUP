//
//  WMSemesterViewController.m
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/14/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//
//REMINDER: arrayOfSemesterObjects contains actual semester objects, not just the titles, but the entire objects.

#import "WMSemesterViewController.h"


@interface WMSemesterViewController ()

@end

@implementation WMSemesterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    
    //Need to allocate and initialize arrayOfSemesterObjects array:
    self.arrayOfSemesterObjects = [[NSMutableArray alloc] init];
    self.arrayOfCredits = [[NSMutableArray alloc] init];
    self.arrayOfGrades = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    //Need to reset the semester array and number of semesters:
    [self.arrayOfSemesterObjects removeAllObjects];
    numSemesters = 0;
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //Find all the semester objects and put them into the array:
    //Note: a semester object is identical to a course object,
    //but the profName field has been set to nil:
    //Pull the course object with this title out of memory:
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    
   // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.profName like %@",@""];
    
   //[request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (array != nil) {
        for(Course *semesters in array){
            if([semesters.profName isEqualToString:@""]){
                    [self.arrayOfSemesterObjects addObject:semesters];
                    numSemesters++;
            }
        }
    }
    
    //We now have all of the semester titles pulled out of memory that need to be displayed
    
    
    //Pull all of the course objects off the core and store their credits as well as their current letter grade:
    NSFetchRequest *secondRequest = [[NSFetchRequest alloc] init];
    [secondRequest setEntity:entity];
    
    NSArray *secondArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (secondArray != nil) {
        for(Course *courses in array){
            if(![courses.profName isEqualToString:@""]){
                [self.arrayOfGrades addObject:[courses currentGrade]];
                [self.arrayOfCredits addObject:[courses numCredits]];
                hasF = [courses hasF];
            }
        }
    }
    
    
    
    //Display an add button. If it is pressed, call the dispalySemesterAddForm Method:
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displaySemesterAddForm)];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    
}

//This method is used to create the section headers:
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"List of Semesters";
    }
    else{
        return @"Options";
    }
}

//To Make the Edit Button delete functionality:
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

//This gets called when the delete button is pressed in edit mode:
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WMCourseObject *semesterToBeDeleted = [self.arrayOfSemesterObjects objectAtIndex:indexPath.row];
   
    NSString *semesterTitle = [semesterToBeDeleted semesterTitle];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        //Need to find all the course objects we want to delete:
        NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
    
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"semesterTitle like %@", semesterTitle];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (array == nil)
        {
            // Deal with error...
        }
        //Now let's delete them all:
        for(Course *courses in array){
            [self.managedObjectContext deleteObject:courses];
        }
        [self.arrayOfSemesterObjects removeObjectAtIndex:indexPath.row];
         --numSemesters;
        
        [self.managedObjectContext save:&error];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void) displaySemesterAddForm
{
    WMSemesterAddFormViewController *semesterAddForm = [[WMSemesterAddFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [semesterAddForm setTitle:self.title];
    [semesterAddForm setManagedObjectContext:self.managedObjectContext];
    [self.navigationController pushViewController:semesterAddForm animated:YES];
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
        return 2;
    }
    if (section == 1) {
        return numSemesters;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Use the arrayOfSemesterObjects to display the table; this array will also
    //be used to delete them:
    
    double score = 0;
    double totalCredits = 0;
    int i = 0;
    for (i = 0; i < [self.arrayOfGrades count]; i++) {
        if ([[self.arrayOfGrades objectAtIndex:i] doubleValue] != 0 || hasF) {
            score += ([[self.arrayOfGrades objectAtIndex:i] doubleValue] * [[self.arrayOfCredits objectAtIndex:i] doubleValue]);
            totalCredits += [[self.arrayOfCredits objectAtIndex:i] doubleValue];
        }
    }
    
    double displayScore = 0;
    
    if (i != 0) {
        displayScore = score/totalCredits;
    }
    
    //Make a custom cell:
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"courseCell"];
    }
    
    // Configure the cell...
    if (indexPath.section == 1) {
        
        Course *semesterObject = self.arrayOfSemesterObjects[indexPath.row];
    
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",semesterObject.semesterTitle]];
    }
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:[NSString stringWithFormat:@"Add a Semester"]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        if (indexPath.row == 1) {
            NSMutableString *displayString = [[NSMutableString alloc] init];
            if (displayScore == 0 && hasF != YES) {
                [displayString appendString:@"Current Overall GPA"];
            }
            else{
                [displayString appendString:[NSString stringWithFormat:@"Current Overall GPA: %.2f", displayScore ]];
            }
            [cell.textLabel setText:displayString];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }
    }
    
    
    return cell;
}

//This method is called when a section (indexPath.row) is clicked on by the user:
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        WMListOfCoursesViewController *viewController = [[WMListOfCoursesViewController alloc] initWithStyle:UITableViewStyleGrouped];
        WMCourseObject *semester = [self.arrayOfSemesterObjects objectAtIndex:indexPath.row];
        [viewController setSemesterTitle:[semester semesterTitle]];
        [viewController setTitle:[semester semesterTitle]];
        [viewController setManagedObjectContext:self.managedObjectContext];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        if (indexPath.row == 0) {
            [self displaySemesterAddForm];
        }
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return YES;
    }
    else{
        return NO;
    }
   
}




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

//Delegate Method: reloads the view when the submit button on the form is pressed:
-(void) reloadData{
    [self viewDidLoad];
    [self.tableView reloadData];
}


@end
