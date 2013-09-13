//
//  RootTableViewController.m
//  ParseStarterProject
//
//  Created by Derek Schumacher on 8/13/13.
//
//

#import "RootTableViewController.h"
#import "WMConstants.h"

@interface RootTableViewController ()

@end

@implementation RootTableViewController

//Delegate method: The add form adds the courseName of the course just added to the courseNameArray, a property of this class:
-(void) addCourse:(NSString *)courseName{
    //[courseNameArray addObject:courseName];
    [courseNameArray removeAllObjects];
    [self.tableView reloadData];
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
    self.navigationItem.title = @"Class Manager";
    PURPLEBACK
    
    //To set up the use of a custom Cell (in the XIB file):
    
    //Load the NIB File
    UINib *nib = [UINib nibWithNibName:@"WMCourseCell" bundle: nil];
    
    //Register this NIB which containts the cell
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"courseCell"];
    
    //Make the add button:
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displayNextViewController)];
    [[[self navigationItem] rightBarButtonItem] setTintColor:PURPLECOLOR];
    
    courseNameArray = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [[[self navigationItem] leftBarButtonItem] setTintColor:PURPLECOLOR];
}
//To Make the Edit Button and delete functionality:
- (void)setEditing:(BOOL)editing animated:(BOOL)animated { 
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { //implement the delegate method
    //Delete the grade object associated with the course as well**************
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int indexToBeDeleted = indexPath.row;
        
        //If the delete button is pressed:
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //Pull out object to be deleted from core data, using the CourseNameArray, delete all grade objects:
            NSManagedObjectContext *context = self.managedObjectContext;
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity =
            [NSEntityDescription entityForName:@"Course"
                        inManagedObjectContext:context];
            [request setEntity:entity];
            
            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"self.courseTitle like %@", [courseNameArray objectAtIndex:indexPath.row]];
            [request setPredicate:predicate];
            
            NSError *error;
            NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
            
            //Should only be one object in this array, unless the user entered two classes with the same
            //name (which should not be possibe, due to error checking in the addCourse form):
            Course *objectToBeDeleted = [array objectAtIndex:0];
            
            [context deleteObject: objectToBeDeleted];
            [context save:&error];
            
            //Check to make sure the object is deleted:
            /*
            if (objectToBeDeleted.managedObjectContext == nil) {
                NSLog(@"Successful Deletion");
            }
            */
            
            //Find all the grade objects associated with the course and delete those as well:
            NSFetchRequest *secondRequest = [[NSFetchRequest alloc] init];
            entity = [NSEntityDescription entityForName:@"Grade" inManagedObjectContext:context];
            [secondRequest setEntity: entity];
            NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"self.courseTitle like %@" , [courseNameArray objectAtIndex:indexPath.row]];
            [secondRequest setPredicate:secondPredicate];
            
            NSArray *secondArray = [self.managedObjectContext executeFetchRequest:secondRequest error:&error];
            //Loop to delete all objects in the array:
            int indexVar = 0;
            for (Grade *objects in secondArray) {
                [context deleteObject:[secondArray objectAtIndex:indexVar]];
                indexVar++;
            }
            
            [courseNameArray removeObjectAtIndex:indexToBeDeleted];
            [context save:&error];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        /*
        PFObject *object = [self.objects objectAtIndex:indexToBeDeleted];
        
        [object deleteInBackground];
        */
       // [self.tableView reloadData];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) displayNextViewController
{
    //Make the next view controller, then push it:
    WMCourseAddFormViewController *controller = [[WMCourseAddFormViewController alloc] init];
    [controller setManagedObjectContext:self.managedObjectContext];
    [controller setCourseDelegate:(id) self];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

//Find out how many course objects are stored:
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext]];
    
    [request setIncludesSubentities:NO]; //Omit subentities.
    
    NSError *error;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    //index = count;
    if(count == NSNotFound) {
        //Handle error
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong. Please try again. If the problem persists, contact the app creators" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [errorMessage show];
    }
    /*
    if (section == 0) {
        return 1;
    }
    else{
     */
        return count;
    //}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(20, 5, 300, 300)];
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, 300, 300)];
    [tv setEditable:NO];
    [tv setText:@"Click \"+\" to add a class."];
    [tv setBackgroundColor:[UIColor clearColor]];
    [theView addSubview:tv];
    [tv setFont:[UIFont systemFontOfSize:12]];
    [tv setTextAlignment:NSTextAlignmentCenter];
    return theView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    //Make a custom cell:
    WMCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
    if (cell == nil) {
        cell = [[WMCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"courseCell"];
    }
    
    //if (indexPath.section == 1) {
        
    
        //Pull the info off the core:
        NSManagedObjectContext *context = [self managedObjectContext];
        NSError *error;
        NSFetchRequest *request= [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
        [request setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
        Course *course;
        if (fetchedObjects && fetchedObjects.count != 0) {
            
            course = [fetchedObjects objectAtIndex:indexPath.row];
            //Set the course number
            [[cell courseTitleLabel] setText: course.courseTitle];
            //Set the professor name:
            [[cell profNameLabel] setText:course.professorName];
            
            //Set the course Title:
            NSString *courseName = course.courseTitle;
            [courseNameArray addObject:[NSString stringWithFormat:@"%@",courseName]];
            
            return cell;
        
        
            
        }
        else{
            //Error:
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong. Please try again. If the problem persists, contact app creators" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [errorMessage show];
            return cell;
        }
   
    //}
    /*
    else {
        [[cell courseTitleLabel] setText:@"Semester GPA:"];
        [[cell profNameLabel] setTextAlignment:NSTextAlignmentCenter];
        
        //Display gpa:
        [[cell profNameLabel] setText:@"4.00"];
        return cell;
    }
    */

}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Display the view controller for the course:
    WMCourseDetailController *detailController = [[WMCourseDetailController alloc] init];
    detailController.courseName = [courseNameArray objectAtIndex:indexPath.row];
    
    
    //For Core Data:
    detailController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:detailController animated:YES];

}

@end
