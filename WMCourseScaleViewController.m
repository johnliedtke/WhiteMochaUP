//
//  WMCourseScaleViewController.m
//  ParseStarterProject
//
//  Created by Derek Schumacher on 8/17/13.
//
//

#import "WMCourseScaleViewController.h"

@interface WMCourseScaleViewController ()

@end

@implementation WMCourseScaleViewController

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //Pull the scale off the core and display it, if the user has not entered them in display the default scale:
    NSString *aValue = @"93";
    NSString *aMinusValue = @"90";
    NSString *bPlusValue = @"87";
    NSString *bValue = @"83";
    NSString *bMinusValue = @"80";
    NSString *cPlusValue = @"77";
    NSString *cValue = @"73";
    NSString *cMinusValue = @"70";
    NSString *dPlusValue = @"67";
    NSString *dValue = @"63";
    NSString *dMinusValue = @"60";
    NSString *fValue = @"60";
    
    
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
        for (Course *courses in array) {
            if ([courses.courseTitle isEqualToString:self.courseName]) {
                //Set the grade values to be those stored on the Core
                //Check to see if the aValue is there. We don't need to check the others
                //because the form forces them to put them all in:
                if (courses.aValue && ![courses.aValue isEqualToString:@""]) {
                    
                    aValue = courses.aValue;
                    aMinusValue = courses.aMinusValue;
                    bPlusValue = courses.bPlusValue;
                    bValue =  courses.bValue;
                    bMinusValue = courses.bMinusValue;
                    cPlusValue = courses.cPlusValue;
                    cValue = courses.cValue;
                    cMinusValue = courses.cMinusValue;
                    dPlusValue = courses.dPlusValue;
                    dValue = courses.dValue;
                    dMinusValue = courses.dMinusValue;
                    fValue = courses.fValue;
                }
            }
        }
    }
    else {
        // Deal with error.
    }
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:[NSString stringWithFormat:@"An A is a %@ %% or above", aValue]];
            break;
        case 1:
            [cell.textLabel setText: [NSString stringWithFormat:@"An A- is a %@ %% or above", aMinusValue]];
            break;
        case 2:
            [cell.textLabel setText:[NSString stringWithFormat:@"An B+ is a %@ %% or above", bPlusValue]];
            break;
        case 3:
            [cell.textLabel setText:[NSString stringWithFormat:@"A B is a %@ %% or above", bValue]];
            break;
        case 4:
            [cell.textLabel setText:[NSString stringWithFormat:@"A B- is a %@ %% or above", bMinusValue]];
            break;
        case 5:
            [cell.textLabel setText:[NSString stringWithFormat:@"A C+ is a %@ %% or above", cPlusValue]];
            break;
        case 6:
            [cell.textLabel setText:[NSString stringWithFormat:@"A C is a %@ %% or above", cValue]];
            break;
        case 7:
            [cell.textLabel setText:[NSString stringWithFormat:@"A C- is a %@ %% or above", cMinusValue]];
            break;
        case 8:
            [cell.textLabel setText:[NSString stringWithFormat:@"A D+ is a %@ %% or above", dPlusValue]];
            break;
        case 9:
            [cell.textLabel setText:[NSString stringWithFormat:@"A D is a %@ %% or above", dValue]];
            break;
        case 10:
            [cell.textLabel setText:[NSString stringWithFormat:@"A D- is a %@ %% or above", dMinusValue]];
            break;
        case 11:
            [cell.textLabel setText:[NSString stringWithFormat:@"An F is anything lower than %@ %%", fValue]];
            break;
        default:
            break;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
