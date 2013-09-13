//
//  WMCourseWeightsDisplayViewController.m
//  ParseStarterProject
//
//  Created by Derek Schumacher on 8/12/13.
//
//

#import "WMCourseWeightsDisplayViewController.h"


@interface WMCourseWeightsDisplayViewController ()

@end

@implementation WMCourseWeightsDisplayViewController

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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //Pull the weights out of the core and display them:
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Course"
                inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"self.courseTitle like %@", self.courseName];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) {
        //NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        //
    }
    else {
        // Deal with error.
    }
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    Course *foundObject = [array objectAtIndex:0];
    
    if (indexPath.row == 0) {
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        NSString *weightLabel = @"No Weight";
        if (foundObject.quizWeight) {
            weightLabel = [NSString stringWithFormat:@"%@ %%", foundObject.quizWeight];
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"Quiz Weight: %@", weightLabel]];
        return cell;
    }
    
    if (indexPath.row == 1) {
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        NSString *weightLabel = @"No Weight";
        if (foundObject.essayWeight) {
            weightLabel = [NSString stringWithFormat:@"%@ %%", foundObject.essayWeight];
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"Essay Weight: %@", weightLabel]];
        return cell;
    }
    
    if (indexPath.row == 2) {
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        NSString *weightLabel = @"No Weight";
        if (foundObject.homeworkWeight) {
            weightLabel = [NSString stringWithFormat:@"%@ %%", foundObject.homeworkWeight];
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"Homework Weight: %@", weightLabel]];
        return cell;
    }
    
    if (indexPath.row == 3) {
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        NSString *weightLabel = @"No Weight";
        if (foundObject.testWeight) {
            weightLabel = [NSString stringWithFormat:@"%@ %%", foundObject.testWeight];
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"Test Weight: %@", weightLabel]];
        return cell;
    }
    
    if (indexPath.row == 4) {
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        NSString *weightLabel = @"No Weight";
        if (foundObject.otherWeight) {
            weightLabel = [NSString stringWithFormat:@"%@ %%", foundObject.otherWeight];
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"Other Weight: %@", weightLabel]];
        return cell;
    }
    
    if (indexPath.row == 5) {
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        NSString *weightLabel = @"No Weight";
        if (foundObject.finalExamWeight) {
            weightLabel = [NSString stringWithFormat:@"%@ %%", foundObject.finalExamWeight];
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"Final Weight: %@", weightLabel]];
        return cell;
    }
    
    if (indexPath.row == 6) {
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        NSString *weightLabel = @"No Weight";
        if (foundObject.attendanceWeight) {
            weightLabel = [NSString stringWithFormat:@"%@ %%", foundObject.attendanceWeight];
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"Attendance Weight: %@", weightLabel]];
        return cell;
    }
    // Configure the cell...
    else{
        return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
