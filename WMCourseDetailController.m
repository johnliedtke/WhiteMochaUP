//
//  WMCourseDetailController.m
//  ParseStarterProject
//
//  Created by Derek Schumacher on 7/26/13.
//
//

#import "WMCourseDetailController.h"
#import "WMConstants.h"


@interface WMCourseDetailController ()

@end

@implementation WMCourseDetailController

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
    PURPLEBACK
    
    [self setTitle: @"Current Grades"];
    //Load the NIB file:
    UINib *nib = [UINib nibWithNibName:@"WMCourseDetailCell" bundle:nil];
    
    //Register this NIB which contains the cell:
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"courseDetailCell"];
    
    
    /*
     
     */
    
    //Make the grade tracker button:
    /*
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(displayTrackerForm)];
     */
    //Make the add button:
    /*
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displayNextViewController)];
     */
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//Method so the add button works: Displays the next view controller:
-(void) displayNextViewController
{
    
    WMCourseAddFormViewController *controller = [[WMCourseAddFormViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void) displayTrackerForm
{
    WMCourseTrackGradeViewController *controller = [[WMCourseTrackGradeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
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
    return 7;
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
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    
    //Make the custom cell:
    if (indexPath.section == 0){
        WMCourseDetailCell *customCell = (WMCourseDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"courseDetailCell"];
        
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
        // Configure the cell...
        //************ make sure to add attendance, other, and final exam to this portion as well*************
        //Dual arrays for now, very weak, will later implement a data structure
        //to match the scores with the maximum possible points:
        //Arrays to store all the scores:
        NSMutableArray *testScores= [[NSMutableArray alloc] init];
        NSMutableArray *essayScores= [[NSMutableArray alloc] init];
        NSMutableArray *homeworkScores= [[NSMutableArray alloc] init];
        NSMutableArray *quizScores= [[NSMutableArray alloc] init];
        NSMutableArray *attendanceScores = [[NSMutableArray alloc] init];
        NSMutableArray *finalScore = [[NSMutableArray alloc] init];
        NSMutableArray *otherScores = [[NSMutableArray alloc] init];
        
        NSMutableArray *maxTestScores= [[NSMutableArray alloc] init];
        NSMutableArray *maxEssayScores= [[NSMutableArray alloc] init];
        NSMutableArray *maxHomeworkScores= [[NSMutableArray alloc] init];
        NSMutableArray *maxQuizScores= [[NSMutableArray alloc] init];
        NSMutableArray *maxAttendanceScores = [[NSMutableArray alloc] init];
        NSMutableArray *maxFinalScore = [[NSMutableArray alloc] init];
        NSMutableArray *maxOtherScores = [[NSMutableArray alloc] init];
        
        //Do some stuff: Pull the grades out of memory:
        //Pull the info off the core, if it is there:
        NSManagedObjectContext *context = [self managedObjectContext];
        NSError *error;
        NSFetchRequest *request= [[NSFetchRequest alloc] init];
        
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Grade" inManagedObjectContext:context];
        [request setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
        for (Grade *grades in fetchedObjects){
            NSString *selector = grades.gradeType;
            
            if([grades.courseTitle isEqualToString:self.courseName]){
            
                if ([selector isEqualToString:@"Test"]) {
                    [testScores addObject:grades.courseScore];
                    [maxTestScores addObject:grades.maxPoints];
                }
                if ([selector isEqualToString:@"Quiz"]) {
                    [quizScores addObject:grades.courseScore];
                    [maxQuizScores addObject:grades.maxPoints];
                }
                if ([selector isEqualToString:@"Essay"]) {
                    [essayScores addObject:grades.courseScore];
                    [maxEssayScores addObject:grades.maxPoints];
                }
                if ([selector isEqualToString:@"Homework"]) {
                    [homeworkScores addObject:grades.courseScore];
                    [maxHomeworkScores addObject:grades.maxPoints];
                }
                if ([selector isEqualToString:@"Other"]) {
                    [otherScores addObject:grades.courseScore];
                    [maxOtherScores addObject:grades.maxPoints];
                }
                if ([selector isEqualToString:@"Attendance"]) {
                    [attendanceScores addObject:grades.courseScore];
                    [maxAttendanceScores addObject:grades.maxPoints];
                }
                if ([selector isEqualToString:@"Final Exam"]) {
                    [finalScore addObject:grades.courseScore];
                    [maxFinalScore addObject:grades.maxPoints];
                }
            }
            
        }
        
        //We now have all the scores for the course selected stored in the arrays:
        //Send the scores to the calcualte grade method:
        NSString *grade = [[NSString alloc] init];
        grade = [self calculateGradewithQuizScores:quizScores essayScores:essayScores testScores:testScores homeworkScores:homeworkScores attendanceScores:attendanceScores finalExamScores:finalScore otherScores:otherScores maxQuizScores:maxQuizScores maxEssayScores:maxEssayScores maxTestScores:maxTestScores maxHomeworkScores:maxHomeworkScores maxAttendaceScores:maxAttendanceScores maxFinalExamScore:maxFinalScore maxOtherScores:maxOtherScores];
        
        [[customCell detailCellCourse] setText:self.courseName];
        [[customCell detailCellGrade] setText:[NSString stringWithFormat:@"Grade: %@", grade]];
        return customCell;
    }
    
    if (indexPath.section == 1){
        cell.textLabel.text = @"Enter Weights";
        return cell;
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = @"Enter Grades";
        return cell;
    }
    if (indexPath.section == 3) {
        cell.textLabel.text = @"View Course Weights";
        return cell;
    }
    if (indexPath.section == 4) {
        cell.textLabel.text = @"View Grades";
        return cell;
    }
    if (indexPath.section == 5) {
        cell.textLabel.text = @"Enter Custom Grading Scale";
        return cell;
    }
    else{
        cell.textLabel.text = @"View Grading Scale";
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
    if(indexPath.section == 1){
        WMCourseTrackGradeViewController *detailViewController = [[WMCourseTrackGradeViewController alloc]init];
        //Call the delegate Method to send the courseTitle through:
        [detailViewController setCourseTitle:self.courseName];
        [detailViewController setManagedObjectContext:self.managedObjectContext];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    if(indexPath.section == 2){
        WMCourseGradeEntryViewController *nextViewController = [[WMCourseGradeEntryViewController alloc] init];
        [nextViewController setManagedObjectContext:self.managedObjectContext];
        [nextViewController setCourseTitle:self.courseName];
        //For Core Data:
        nextViewController.managedObjectContext = self.managedObjectContext;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    if (indexPath.section == 3) {
        WMCourseWeightsDisplayViewController *weightsController = [[WMCourseWeightsDisplayViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [weightsController setManagedObjectContext:self.managedObjectContext];
        [weightsController setCourseName:self.courseName];
        [self.navigationController pushViewController:weightsController animated:YES];
    }
    if (indexPath.section == 4) {
        WMGradeSheetViewController *nextViewController = [[WMGradeSheetViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [nextViewController setCourseTitle:self.courseName];
        [nextViewController.navigationItem setTitle:@"Grade Sheet"];
        
        //For Core Data:
        nextViewController.managedObjectContext = self.managedObjectContext;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    
    if (indexPath.section == 5) {
        WMCourseChangeGradingScaleViewController *nextViewController = [[WMCourseChangeGradingScaleViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [nextViewController setCourseTitle:self.courseName];
        [nextViewController.navigationItem setTitle:@"Set Grading Scale"];
        
        //For Core Data:
        nextViewController.managedObjectContext = self.managedObjectContext;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    
    if (indexPath.section == 6) {
        WMCourseScaleViewController *nextViewController = [[WMCourseScaleViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [nextViewController setCourseName:self.courseName];
        [nextViewController.navigationItem setTitle:@"Grading Scale"];
        
        //For Core Data:
        nextViewController.managedObjectContext = self.managedObjectContext;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}


-(NSString *) calculateGradewithQuizScores: (NSMutableArray *) quizScores essayScores: (NSMutableArray *) essayScores testScores: (NSMutableArray *) testScores homeworkScores: (NSMutableArray *) homeworkScores attendanceScores: (NSMutableArray *) attendanceScores finalExamScores: (NSMutableArray *) finalExamScores otherScores: (NSMutableArray *) otherScores maxQuizScores: (NSMutableArray *) maxQuizScores maxEssayScores: (NSMutableArray *) maxEssayScores maxTestScores: (NSMutableArray *) maxTestScores maxHomeworkScores: (NSMutableArray *) maxHomeworkScores maxAttendaceScores: (NSMutableArray *) maxAttendanceScores maxFinalExamScore: (NSMutableArray *) maxFinalExamScore maxOtherScores: (NSMutableArray *) maxOtherScores{
    
    NSString *aValue;
    NSString *aMinusValue; 
    NSString *bPlusValue;
    NSString *bValue;
    NSString *bMinusValue;
    NSString *cPlusValue;
    NSString *cValue;
    NSString *cMinusValue;
    NSString *dPlusValue; 
    NSString *dValue;
    NSString *dMinusValue;
    NSString *fValue;
    //Pull the weights and custom grading scale (if it is there) off the Core:
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
    Course *course;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) {
        course = [array objectAtIndex:0];
       // NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        //
    }
    else {
        // Deal with error.
    }
     
    self.essayWeight = course.essayWeight;
    self.homeworkWeight = course.homeworkWeight;
    self.testWeight = course.testWeight;
    self.attendanceWeight = course.attendanceWeight;
    self.otherWeight = course.otherWeight;
    self.finalExamWeight = course.finalExamWeight;
    self.quizWeight = course.quizWeight;
    
    aValue = course.aValue;
    aMinusValue = course.aMinusValue;
    bPlusValue = course.bPlusValue;
    bValue = course.bValue;
    bMinusValue = course.bMinusValue;
    cPlusValue = course.cPlusValue;
    cValue = course.cValue;
    cMinusValue = course.cMinusValue;
    dPlusValue = course.dPlusValue;
    dValue = course.dValue;
    dMinusValue = course.dMinusValue;
    fValue = course.fValue;
    
    //NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
   
    
    
    
    double totalQuizPoints = 0;
    double totalTestPoints = 0;
    double totalEssayPoints = 0;
    double totalHomeoworkPoints = 0;
    double totalAttendancePoints = 0;
    double totalOtherPoints = 0;
    double totalFinalExamPoints = 0;
    
    double possibleQuizPoints = 0;
    double possibleTestPoints = 0;
    double possibleEssayPoints = 0;
    double possibleHomeworkPoints = 0;
    double possibleAttendancePoints = 0;
    double possibleOtherPoints = 0;
    double possibleFinalExamPoints = 0;
    
    //Compute the max values for each category:
    for (NSString *values in maxQuizScores) {
        possibleQuizPoints = possibleQuizPoints + [values doubleValue];
    }
    
    for (NSString *values in maxTestScores) {
        possibleTestPoints = possibleTestPoints + [values doubleValue];
    }
    for (NSString *values in maxEssayScores) {
        possibleEssayPoints = possibleEssayPoints + [values doubleValue];
    }
    for (NSString *values in maxHomeworkScores) {
        possibleHomeworkPoints = possibleHomeworkPoints + [values doubleValue];
    }
    for (NSString *values in maxAttendanceScores) {
        possibleAttendancePoints = possibleAttendancePoints + [values doubleValue];
    }
    for (NSString *values in maxOtherScores) {
        possibleOtherPoints = possibleOtherPoints + [values doubleValue];
    }
    
    if (maxFinalExamScore && maxFinalExamScore.count) {
        possibleFinalExamPoints = [[maxFinalExamScore objectAtIndex:0] doubleValue];
    }
    //Compute the total points earned, by category:
    for (NSString *values in quizScores) {
        totalQuizPoints = totalQuizPoints + [values doubleValue];
    }
    
    for (NSString *values in testScores) {
        totalTestPoints = totalTestPoints + [values doubleValue];
    }
    for (NSString *values in essayScores) {
        totalEssayPoints = totalEssayPoints + [values doubleValue];
    }
    for (NSString *values in homeworkScores) {
        totalHomeoworkPoints = totalHomeoworkPoints + [values doubleValue];
    }
    for (NSString *values in attendanceScores) {
        totalAttendancePoints = totalAttendancePoints + [values doubleValue];
    }
    for (NSString *values in otherScores) {
        totalOtherPoints = totalOtherPoints + [values doubleValue];
    }
    if (finalExamScores && finalExamScores.count) {
        totalFinalExamPoints = [[finalExamScores objectAtIndex:0] doubleValue];
    }
    
    
    double quizScore = 0;
    double testScore = 0;
    double essayScore = 0;
    double homeworkScore = 0;
    double attendanceScore = 0;
    double otherScore = 0;
    double finalScore = 0;
    
    //Check and see how to not truncate this:
    //Find the total amount of entered weight, with scores:
    double totalWeight = 0;
    if (possibleQuizPoints != 0) {
        quizScore = totalQuizPoints/possibleQuizPoints;
        totalWeight = totalWeight + [self.quizWeight doubleValue];
    }
    if(possibleTestPoints != 0){
        testScore = totalTestPoints/possibleTestPoints;
        totalWeight = totalWeight + [self.testWeight doubleValue];
    }
    if (possibleEssayPoints != 0) {
        essayScore = totalEssayPoints/possibleEssayPoints;
        totalWeight = totalWeight + [self.essayWeight doubleValue];
    }
    if (possibleHomeworkPoints != 0) {
        homeworkScore = totalHomeoworkPoints/possibleHomeworkPoints;
        totalWeight = totalWeight + [self.homeworkWeight doubleValue];
    }
    if (possibleAttendancePoints != 0) {
        attendanceScore = totalAttendancePoints/possibleAttendancePoints;
        totalWeight = totalWeight + [self.attendanceWeight doubleValue];
    }
    if (possibleOtherPoints != 0) {
        otherScore = totalOtherPoints/possibleOtherPoints;
        totalWeight = totalWeight + [self.otherWeight doubleValue];
    }
    if (possibleFinalExamPoints != 0) {
        finalScore = totalFinalExamPoints/possibleFinalExamPoints;
        totalWeight = totalWeight + [self.finalExamWeight doubleValue];
    }
    
    
    
    
    
    double currentGrade = 0;
    currentGrade = quizScore * [self.quizWeight doubleValue] + testScore * [self.testWeight doubleValue] + essayScore * [self.essayWeight doubleValue] + homeworkScore * [self.homeworkWeight doubleValue] + otherScore * [self.otherWeight doubleValue] + finalScore * [self.finalExamWeight doubleValue] + attendanceScore * [self.attendanceWeight doubleValue];
    
    /*
    //Compute the total weight:
    if (quizScore != 0) {
        totalWeight += [self.quizWeight doubleValue];
    }
    if (testScore != 0) {
        totalWeight += [self.testWeight doubleValue];
    }
    if (essayScore != 0) {
        totalWeight += [self.essayWeight doubleValue];
    }
    if (homeworkScore != 0) {
        totalWeight += [self.homeworkWeight doubleValue];
    }
    if (otherScore != 0) {
        totalWeight += [self.otherWeight doubleValue];
    }
    if (finalScore != 0) {
        totalWeight += [self.finalExamWeight doubleValue];
    }
    if (attendanceScore != 0) {
        totalWeight += [self.finalExamWeight doubleValue];
    }
    */
    
    if (self.essayWeight == 0 && self.quizWeight == 0 && self.testWeight == 0 && self.homeworkWeight == 0 && self.otherWeight == 0 && self.finalExamWeight == 0 && self.attendanceWeight == 0) {
        //The user has not entered any weights:
        return @"Missing Weights";
    }
    currentGrade = ((currentGrade) /totalWeight) * 100;
    
    if (aValue && ![aValue isEqualToString:@""] && aMinusValue && ![aMinusValue isEqualToString:@""] && bPlusValue && ![bPlusValue isEqualToString:@""] && bValue && ![bValue isEqualToString:@""] && bMinusValue && ![bMinusValue isEqualToString:@""] && cPlusValue && ![cPlusValue isEqualToString:@""] && cValue && ![cValue isEqualToString:@""] && cMinusValue && ![cMinusValue isEqualToString:@""] && dPlusValue && ![dPlusValue isEqualToString:@""]&& dValue && ![dValue isEqualToString:@""] && dMinusValue && ![dMinusValue isEqualToString:@""] && fValue && ![fValue isEqualToString:@""]) {
        //Set new scale:
        if (currentGrade >= [aValue doubleValue]){
            return @"A";
        }
        if (currentGrade >= [aMinusValue doubleValue]){
            return @"A-";
        }
        if (currentGrade >= [bPlusValue doubleValue]){
            return @"B+";
        }
        if (currentGrade >= [bValue doubleValue]) {
            return @"B";
        }
        if (currentGrade >= [bMinusValue doubleValue]){
            return @"B-";
        }
        if (currentGrade >= [cPlusValue doubleValue]){
            return @"C+";
        }
        if (currentGrade >= [cValue doubleValue]) {
            return @"C";
        }
        if (currentGrade >= [cMinusValue doubleValue]){
            return @"C-";
        }
        if (currentGrade >= [dPlusValue doubleValue]){
            return @"D+";
        }
        if (currentGrade >= [dValue doubleValue]) {
            return @"D";
        }
        if (currentGrade >= [dMinusValue doubleValue]){
            return @"D-";
        }
        if (currentGrade <= [fValue doubleValue]) {
            return @"F";
        }
        else{
            return @"No Grades";
        }
    }
    else{
        //Use Default scale
        if (currentGrade >= 97.00){
            return @"A";
        }
        if (currentGrade >= 90.00){
            return @"A-";
        }
        if (currentGrade >= 87.00){
            return @"B+";
        }
        if (currentGrade >= 83.00) {
            return @"B";
        }
        if (currentGrade >= 80.00){
            return @"B-";
        }
        if (currentGrade >= 77.00){
            return @"C+";
        }
        if (currentGrade >= 73.00) {
            return @"C";
        }
        if (currentGrade >= 70.00){
            return @"C-";
        }
        if (currentGrade >= 67.00){
            return @"D+";
        }
        if (currentGrade >= 63.00) {
            return @"D";
        }
        if (currentGrade >= 60.00){
            return @"D-";
        }
        if (currentGrade <= 60.00) {
            return @"F";
        }
        else{
            return @"No Grades";
        }
    }
    //Default Grading Scale:
    
    [self loadView];
}

@end
