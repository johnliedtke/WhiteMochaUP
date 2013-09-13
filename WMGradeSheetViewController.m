//
//  WMGradeSheetViewController.m
//  ParseStarterProject
//
//  Created by Derek Schumacher on 8/3/13.
//
//

#import "WMGradeSheetViewController.h"


@interface WMGradeSheetViewController ()

@end

@implementation WMGradeSheetViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    index = 0;
    gradeNameArray = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    //self.courseTitle = self.navigationController.title;
    
    //Load the NIB file:
    UINib *nib = [UINib nibWithNibName:@"WMCourseGradeSheetCell" bundle:nil];
    
    //Register this NIB which contains the cell:
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"courseGradeSheetCell"];
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Grade" inManagedObjectContext:context];
    [request setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    for (Grade *grades in fetchedObjects) {
        //NSLog(@"Name: %@", grades.courseTitle);
        if ([grades.courseTitle isEqualToString: self.courseTitle]) {
            numberGrades++;
        }
        //numberGrades++;
    }
    
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { //implement the delegate method
    //Delete the grade object associated with the course as well**************
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Delete the object:
        //Find the object in memory:
        NSManagedObjectContext *context = self.managedObjectContext;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity =
        [NSEntityDescription entityForName:@"Grade"
                    inManagedObjectContext:context];
        [request setEntity:entity];
        [gradeNameArray objectAtIndex:indexPath.row];
        //NSString *Meow = [gradeNameArray objectAtIndex:indexPath.row];
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"self.assignmentName like %@", [gradeNameArray objectAtIndex:indexPath.row]];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        //Should only be one object in this array, unless the user entered two classes with the same
        //name:
        Grade *objectToBeDeleted = [array objectAtIndex:0];
        //NSString *meow = objectToBeDeleted.courseTitle;
        
        [context deleteObject: objectToBeDeleted];
        [context save:&error];
        
        if (objectToBeDeleted.managedObjectContext == nil) {
            // Assume that the managed object has been deleted.
            numberGrades--;
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
            if (![self.managedObjectContext save:&error]) {
                // Handle the error.
            }
            UIAlertView *successMessage = [[UIAlertView alloc] initWithTitle:@"Success!" message:[NSString stringWithFormat:@"Successfully deleted grade from %@", self.courseTitle] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [successMessage show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
        
    }
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
    else{
        return numberGrades;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setText:self.courseTitle];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else{
        WMCourseGradeSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseGradeSheetCell"];
        if(cell == nil){
            cell = [[WMCourseGradeSheetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"courseGradeSheetCell"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        // Configure the cell...
        NSString *courseTitle;
        NSString *score;
        NSString *maxPoints;
        NSString *gradeType;
        NSString *assignmentName; 
        
        
        //Pull the info off the core:
        NSManagedObjectContext *context = [self managedObjectContext];
        NSError *error;
        NSFetchRequest *request= [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Grade" inManagedObjectContext:context];
        [request setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
        NSMutableArray *thisCourseGradesArray = [[NSMutableArray alloc] init];
        
        int counter = 0;
        for (Grade * grade in fetchedObjects) {
            if([grade.courseTitle isEqualToString:self.courseTitle]){
                [thisCourseGradesArray insertObject:grade atIndex:0];
                counter++;
            }
        }
        
        Grade *gradeToDisplay = [thisCourseGradesArray objectAtIndex:indexPath.row];
        if (thisCourseGradesArray) {
            courseTitle = gradeToDisplay.courseTitle;
            score = gradeToDisplay.courseScore;
            maxPoints = gradeToDisplay.maxPoints;
            gradeType = gradeToDisplay.gradeType;
            assignmentName = gradeToDisplay.assignmentName;
            
            [cell.gradeType setText:assignmentName];
            [cell.scoreFraction setText:[NSString stringWithFormat:@"%@ / %@", score, maxPoints]];
            NSString *percent;
            percent = [NSString stringWithFormat:@" %.01f ",[score doubleValue]/[maxPoints doubleValue] * 100];
            [cell.scorePercent setText:[NSString stringWithFormat:@"%@%%", percent]];
            [gradeNameArray insertObject:assignmentName atIndex:0];
            return cell;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
    
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
