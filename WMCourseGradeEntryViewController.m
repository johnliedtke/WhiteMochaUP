//
//  WMCourseGradeEntryViewController.m
//  ParseStarterProject
//
//  Created by Derek Schumacher on 7/29/13.
//
//

#import "WMCourseGradeEntryViewController.h"
#import "WMCourseGradeEntryCell.h"
#import "WMCourseGradeFormViewController.h"

@interface WMCourseGradeEntryViewController ()

@end

@implementation WMCourseGradeEntryViewController
-(void) setCourseTitle:(NSString *)courseTitle
{
    self.courseName = courseTitle;
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
    [self setTitle:self.courseName];
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
    return 1;
}
-(void) viewWillDisappear:(BOOL)animated {
    [self.navigationController loadView];
    [super viewWillDisappear:YES];
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
    
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Enter A Quiz Score";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"Enter A Test Score";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"Enter An Essay Score";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"Enter A Homework Score";
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"Enter An Attendance Score";
    }
    if (indexPath.row == 5) {
        cell.textLabel.text = @"Enter A Final Exam Score";
    }
    if (indexPath.row == 6) {
        cell.textLabel.text = @"Enter Other Type of Score";
    }
    
    
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
    // Navigation logic may go here. Create and push another view controller.
    WMCourseGradeFormViewController *controller = [[WMCourseGradeFormViewController alloc] init];
    if(indexPath.row == 0){
        [controller setGradeType:@"Quiz"];
        // [self.navigationController pushViewController:controller animated:YES];
    }
    if(indexPath.row == 1){
        [controller setGradeType:@"Test"];
        //[self.navigationController pushViewController:controller animated:YES];
    }
    if(indexPath.row == 2){
        [controller setGradeType:@"Essay"];
        //[self.navigationController pushViewController:controller animated:YES];
    }
    if(indexPath.row == 3){
        [controller setGradeType:@"Homework"];
        
    }
    if(indexPath.row == 4){
        [controller setGradeType:@"Attendance"];
        
    }
    if(indexPath.row == 5){
        [controller setGradeType:@"Final Exam"];
        
    }
    if(indexPath.row == 6){
        [controller setGradeType:@"Other"];
        
    }
    //For Core Data:
    controller.managedObjectContext = self.managedObjectContext;
    [controller sendCourseTitle:self.courseName];
    
    [self.navigationController pushViewController:controller animated:YES];
}
@end
