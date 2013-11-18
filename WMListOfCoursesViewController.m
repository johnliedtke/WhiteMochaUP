//
//  WMListOfCoursesViewController.m
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/21/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import "WMListOfCoursesViewController.h"

@interface WMListOfCoursesViewController ()

@end

@implementation WMListOfCoursesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    //Need to allocate memory for arrayOfCourseObjects:
    self.arrayOfCourseObjects = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    //Reset numCourses and the arrayOfCourseObjects (for when a new one needs to be added):
    numCourses = 0;
    [self.arrayOfCourseObjects removeAllObjects];
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Pull out all the course objects from Core Data and save them into the arrayOfCourseObjects array:
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (array != nil) {
        for(Course *courses in array){
            if([courses.semesterTitle isEqualToString: [NSString stringWithFormat: @"%@", self.semesterTitle]] && ![courses.profName isEqualToString:@""]){
                [self.arrayOfCourseObjects addObject:courses];
                numCourses ++;
            }
        }
    }

    //Display the add button:
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displayCourseAddForm)];
}

//This method is called when the add button is pressed:
-(void) displayCourseAddForm
{
    WMCourseAddFormViewController *viewController = [[WMCourseAddFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [viewController setTitle:self.title];
    [viewController setManagedObjectContext:self.managedObjectContext];
    [self.navigationController pushViewController:viewController animated:YES];
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
        return 1;
    }
    if (section == 1){
        return numCourses;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Make a custom cell:
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"courseCell"];
    }
    
    if (indexPath.section == 0) {
        [cell.textLabel setText:@"Add a Course"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    }
    
    if (indexPath.section == 1) {
        // Configure the cell...
        
        Course *courseObject = [self.arrayOfCourseObjects objectAtIndex:indexPath.row];
        [cell.textLabel setText:courseObject.courseTitle];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
        UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(120,11, 200, 20)];
        [secondLabel setText:[NSString stringWithFormat:@"%@",courseObject.profName]];
        
        [cell.contentView addSubview:secondLabel];
    }
    
    return cell;
}


//This method is used to create the section headers:
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Options";
    }
    else{
        return @"List of Courses";
    }
}

//This method is called when a section (indexPath.row) is clicked on by the user:
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self displayCourseAddForm];
    }
    
    if (indexPath.section == 1) {
        WMCourseDetailViewController *nextController = [[WMCourseDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [nextController setTitle:[[self.arrayOfCourseObjects objectAtIndex:indexPath.row] courseTitle]];
        [nextController setManagedObjectContext:self.managedObjectContext];
        [self.navigationController pushViewController:nextController animated:YES];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        return NO;
    }
    else{
        return YES;
    }
    
}

//To Make the Edit Button delete functionality:
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WMCourseObject *courseToBeDeleted = [self.arrayOfCourseObjects objectAtIndex:indexPath.row];
        
        NSString *courseTitle = [courseToBeDeleted courseTitle];
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            //Need to find all the course objects we want to delete:
            NSEntityDescription *entityDescription = [NSEntityDescription
                                                      entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDescription];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                      @"semesterTitle like %@", self.semesterTitle];
            [request setPredicate:predicate];
            
            NSError *error;
            NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
            //Note: This fetch grabbed all of the course objects in that semester, this is done just in case the user has entered a course with the same name for two semesters
            if (array == nil)
            {
                // Deal with error...
            }
            
            //Now let's delete the course:
            for(Course *courses in array){
                if ([courses.courseTitle isEqualToString:[NSString stringWithFormat:@"%@", courseTitle]]) {
                    [self.managedObjectContext deleteObject:courses];
                }
            }
            --numCourses;
            [self.arrayOfCourseObjects removeObjectAtIndex:indexPath.row];
            
            [self.managedObjectContext save:&error];
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

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

-(void) reloadCourseData
{
    [self viewDidLoad];
    [self.tableView reloadData];
}

@end
