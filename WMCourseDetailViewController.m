//
//  WMCourseDetailViewController.m
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/29/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import "WMCourseDetailViewController.h"

@interface WMCourseDetailViewController ()

@end

@implementation WMCourseDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        gradeObjectsArray = [[NSMutableArray alloc] init];
        numRows = 4;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    numGrades = 0;
    //Allocate memory for the instance variables:
    [gradeObjectsArray removeAllObjects];
    
    
    //Pull the course object off the core:
    NSFetchRequest *firstRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *firstEntity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.courseTitle like %@",self.title];
    
    [firstRequest setEntity: firstEntity];
    [firstRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *courses = [self.managedObjectContext executeFetchRequest:firstRequest error:&error];
    thisCourse = [courses objectAtIndex:0];
   
    self.aValue = thisCourse.aValue;
    self.aMinusValue = thisCourse.aMinusValue;
    self.bPlusValue = thisCourse.bPlusValue;
    self.bValue = thisCourse.bValue;
    self.bMinusValue = thisCourse.bMinusValue;
    self.cPlusValue = thisCourse.cPlusValue;
    self.cValue = thisCourse.cValue;
    self.cMinusValue = thisCourse.cMinusValue;
    self.dPlusValue = thisCourse.dPlusValue;
    self.dValue = thisCourse.dValue;
    self.dMinusValue = thisCourse.dMinusValue;
    
    //Pull the grade objects associated with this course out of memory, and count them and store them into their array (an instance variable of this class):
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Grades" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    
    //NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (array != nil) {
        for(Grades *grades in array){
            if([grades.courseTitle isEqualToString: [NSString stringWithFormat: @"%@", self.title]]){
                [gradeObjectsArray addObject:grades];
                numGrades ++;
            }
        }
    }
    
    [self calculateCurrentGrade];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//This method is used to create the section headers:
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Options";
    }
    return @"Grades";
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
        return numRows;
    }
    else{
        return numGrades;
    }
}

//This method is called when a section (indexPath.row) is clicked on by the user:
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        WMCourseAddGradeViewController *gradeForm = [[WMCourseAddGradeViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [gradeForm setManagedObjectContext:self.managedObjectContext];
        [gradeForm setTitle:[NSString stringWithFormat:@"%@",self.title]];
        [self.navigationController pushViewController:gradeForm animated:YES];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        WMAddSyllabusFormViewController *syllabusForm = [[WMAddSyllabusFormViewController alloc]initWithStyle:UITableViewStyleGrouped];
        [syllabusForm setManagedObjectContext:self.managedObjectContext];
        [syllabusForm setTitle:[NSString stringWithFormat:@"%@",self.title]];
        [self.navigationController pushViewController:syllabusForm animated:YES];
    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        WMAddGradingScaleViewController *nextForm = [[WMAddGradingScaleViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [nextForm setManagedObjectContext:self.managedObjectContext];
        [nextForm setTitle:[NSString stringWithFormat:@"%@", self.title]];
        [nextForm setCourseTitle:[NSString stringWithFormat:@"%@", self.title]];
        [self.navigationController pushViewController:nextForm animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"courseCell"];
    }
    
    if (currentGrade == nil) {
        currentGrade = @"";
    }
    
    // Configure the cell...
    UISwitch *gpaSwitch = [[UISwitch alloc] init];
    [gpaSwitch addTarget:self action:@selector(displayGrades) forControlEvents:UIControlEventValueChanged];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [cell.textLabel setText:@"Add Course Weights"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
            case 1:
                [cell.textLabel setText: @"Add Assignment"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
            case 2:
                [cell.textLabel setText:@"Add Custom Grading Scale"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
            case 3:
                [cell.textLabel setText:[NSString stringWithFormat:@"Current Grade:   %@", currentGrade]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                break;
            
            default:
                break;
        }
    }
    else{
        Grades *gradeObject = [gradeObjectsArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:gradeObject.assignmentName];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        double assignmentPercent = [gradeObject.assignmentScore doubleValue]/[gradeObject.maxPoints doubleValue] * 100;
       
        
        UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(200,11, 200, 20)];
        [secondLabel setText:[NSString stringWithFormat:@"%.1f %%", assignmentPercent]];
        
        [cell.contentView addSubview:secondLabel];
    }
    
    return cell;
}

-(void) displayGrades
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray *arrayOfIndexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    //Add the grades section to the table view:
    numRows++;
    [self.tableView insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 1) {
        return YES;
    }
    else{
        return NO;
    }
    
    
}




//Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error;
        Grades *objectToBeDeleted = [gradeObjectsArray objectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:objectToBeDeleted];
        --numGrades;
        [gradeObjectsArray removeObjectAtIndex:indexPath.row];
        [self.managedObjectContext save:&error];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
-(void) reloadGradesData
{
    [self viewDidLoad];
    [self.tableView reloadData];
}

-(void) calculateCurrentGrade
{
    //Use the array with all the grade objects in it to calculate the users current grade for this course:
    NSMutableArray *quizScores = [[NSMutableArray alloc] init];
    NSMutableArray *quizMaxScores = [[NSMutableArray alloc] init];
    
    NSMutableArray *testScores = [[NSMutableArray alloc] init];
    NSMutableArray *testMaxScores = [[NSMutableArray alloc] init];
    
    NSMutableArray *essayScores = [[NSMutableArray alloc] init];
    NSMutableArray *essayMaxScores = [[NSMutableArray alloc] init];
    
    NSMutableArray *homeworkScores = [[NSMutableArray alloc] init];
    NSMutableArray *homeworkMaxScores = [[NSMutableArray alloc] init];
    
    NSMutableArray *finalExamScores = [[NSMutableArray alloc] init];
    NSMutableArray *finalExamMaxScores = [[NSMutableArray alloc] init];
    
    NSMutableArray *attendanceScores = [[NSMutableArray alloc] init];
    NSMutableArray *attendanceMaxScores = [[NSMutableArray alloc] init];
    
    NSMutableArray *otherScores = [[NSMutableArray alloc] init];
    NSMutableArray *otherMaxScores = [[NSMutableArray alloc] init];
    
    //Load the scores into their appropriate arrays:
    for(Grades * grade in gradeObjectsArray){
        if ([grade.assignmentType isEqualToString:@"quiz"] || [grade.assignmentType isEqualToString:@"Quiz"]) {
            [quizScores addObject:[grade assignmentScore]];
            [quizMaxScores addObject: [grade maxPoints]];
        }
        if ([grade.assignmentType isEqualToString:@"test"] || [grade.assignmentType isEqualToString:@"Test"]) {
            [testScores addObject:[grade assignmentScore]];
            [testMaxScores addObject: [grade maxPoints]];
        }
        if ([grade.assignmentType isEqualToString:@"essay"] || [grade.assignmentType isEqualToString:@"Essay"]) {
            [essayScores addObject:[grade assignmentScore]];
            [essayMaxScores addObject: [grade maxPoints]];
        }
        if ([grade.assignmentType isEqualToString:@"HW"] || [grade.assignmentType isEqualToString:@"hw"]) {
            [homeworkScores addObject:[grade assignmentScore]];
            [homeworkMaxScores addObject: [grade maxPoints]];
        }
        if ([grade.assignmentType isEqualToString:@"attendance"] || [grade.assignmentType isEqualToString:@"Attendance"]) {
            [attendanceScores addObject:[grade assignmentScore]];
            [attendanceMaxScores addObject: [grade maxPoints]];
        }
        if ([grade.assignmentType isEqualToString:@"Participation"] || [grade.assignmentType isEqualToString:@"participation"]) {
            [attendanceScores addObject:[grade assignmentScore]];
            [attendanceMaxScores addObject: [grade maxPoints]];
        }
        if ([grade.assignmentType isEqualToString:@"other"] || [grade.assignmentType isEqualToString:@"Other"]) {
            [otherScores addObject:[grade assignmentScore]];
            [otherMaxScores addObject: [grade maxPoints]];
        }
        if ([grade.assignmentType isEqualToString:@"Final"] || [grade.assignmentType isEqualToString:@"final"]) {
            [finalExamScores addObject:[grade assignmentScore]];
            [finalExamMaxScores addObject: [grade maxPoints]];
        }
    }
    
//Compute the persons score for each category:
    double overallQuizScore = 0;
    double maxQuizScore = 0;
    
    double overallTestScore = 0;
    double maxTestScore = 0;
    
    double overallEssayScore = 0;
    double maxEssayScore = 0;
    
    double overallHomeworkScore = 0;
    double maxHWScore = 0;
    
    double overallAttendanceScore = 0;
    double maxAttendScore = 0;
    
    double overallOtherScore = 0;
    double maxOtherScore = 0;
    
    double overallFinalExamScore = 0;
    double maxFinalScore = 0;
    
    bool hasQuizScore = false;
    bool hasTestScore = false;
    bool hasEssayScore = false;
    bool hasHWScore = false;
    bool hasAttendanceScore = false;
    bool hasOtherScore = false;
    bool hasFinalExamScore = false;
    
    for (NSString *points in quizScores){
        overallQuizScore += [points doubleValue];
        hasQuizScore = true;
    }
    
    for (NSString *points in quizMaxScores){
        maxQuizScore += [points doubleValue];
    }
    
    for (NSString *points in testScores){
        overallTestScore += [points doubleValue];
        hasTestScore = true;
    }
    
    for (NSString *points in testMaxScores){
        maxTestScore += [points doubleValue];
    }
    
    for (NSString *points in essayScores){
        overallEssayScore += [points doubleValue];
        hasEssayScore = true;
    }
    
    for (NSString *points in essayMaxScores){
        maxEssayScore += [points doubleValue];
    }
    
    for (NSString *points in homeworkScores){
        overallHomeworkScore += [points doubleValue];
        hasHWScore = true;
    }
    
    for (NSString *points in homeworkMaxScores){
        maxHWScore += [points doubleValue];
    }
    
    for (NSString *points in attendanceScores){
        overallAttendanceScore += [points doubleValue];
        hasAttendanceScore = true;
    }
    
    for (NSString *points in attendanceMaxScores){
        maxAttendScore += [points doubleValue];
    }
    
    for (NSString *points in otherScores){
        overallOtherScore += [points doubleValue];
        hasOtherScore = true;
    }
    
    for (NSString *points in otherMaxScores){
        maxOtherScore += [points doubleValue];
    }
    
    for (NSString *points in finalExamScores){
        overallFinalExamScore += [points doubleValue];
        hasFinalExamScore = true;
    }
    
    for (NSString *points in finalExamMaxScores){
        maxFinalScore += [points doubleValue];
    }
    
    double quizScore = overallQuizScore/maxQuizScore;
    double testScore = overallTestScore/maxTestScore;
    double essayScore = overallEssayScore/maxEssayScore;
    double homeworkScore = overallHomeworkScore/maxHWScore;
    double finalScore = overallFinalExamScore/maxFinalScore;
    double otherScore = overallOtherScore/maxOtherScore;
    double attendanceScore = overallAttendanceScore/maxAttendScore;
    
    double quizWeight = [thisCourse.quizWeight doubleValue] * 0.01;
    double testWeight = [thisCourse.testWeight doubleValue] * 0.01;
    double essayWeight = [thisCourse.essayWeight doubleValue] * 0.01;
    double hwWeight = [thisCourse.homeworkWeight doubleValue] * 0.01;
    double participationWeight = [thisCourse.atendanceWeight doubleValue] * 0.01;
    double otherWeight = [thisCourse.otherWeight doubleValue] * 0.01;
    double finalWeight = [thisCourse.finalWeight doubleValue] * 0.01;
    
    //Compute the user's grade in the class:
    //If they have scores entered for the weight, count it, if not then don't count it:
    if (!hasHWScore) {
        hwWeight = 0;
        homeworkScore = 0;
    }
    if (!hasAttendanceScore) {
        participationWeight = 0;
        attendanceScore = 0;
    }
    if (!hasQuizScore) {
        quizWeight = 0;
        quizScore = 0;
    }
    if (!hasTestScore) {
        testScore = 0;
        testWeight = 0;
    }
    if (!hasEssayScore) {
        essayWeight = 0;
        essayScore = 0;
    }
    if (!hasFinalExamScore) {
        finalWeight = 0;
        finalScore = 0;
    }
    if (!hasOtherScore) {
        otherWeight = 0;
        otherScore = 0;
    }
    
    //Compute the user's grade:
    double grade = (quizScore * quizWeight + essayScore * essayWeight + testScore * testWeight + homeworkScore * hwWeight + participationWeight * attendanceScore + otherWeight * otherScore + finalWeight * finalScore)/(quizWeight + essayWeight + participationWeight + hwWeight + testWeight + otherWeight + finalWeight);
    
    double currentGradeValue = 0;
    
    bool custom = NO;
    if (self.aValue) {
        //use the custom grading scale:
        custom = YES;
    }
    
    if (!custom) {
        if (grade > 0.93) {
            currentGrade = @"A";
            currentGradeValue = 4;
            
        }
        else if (grade > 0.89){
            currentGrade = @"A-";
            currentGradeValue = 3.7;
        }
        else if (grade > 0.86) {
            currentGrade = @"B+";
            currentGradeValue = 3.3;
        }
        else if (grade > 0.82) {
            currentGrade = @"B";
            currentGradeValue = 3.0;
        }
        else if (grade > 0.79){
            currentGrade = @"B-";
            currentGradeValue = 2.7;
        }
        else if (grade > 0.76) {
            currentGrade = @"C+";
            currentGradeValue = 2.3;
        }
        else if (grade > 0.72) {
            currentGrade = @"C";
            currentGradeValue = 2.0;
        }
        else if (grade > 0.69) {
            currentGrade = @"C-";
            currentGradeValue = 1.7;
        }
        else if (grade > 0.66) {
            currentGrade = @"D+";
            currentGradeValue = 1.3;
        }
        else if (grade > 0.62) {
            currentGrade = @"D";
            currentGradeValue = 1.0;
        }
        else if (grade > 0.60) {
            currentGrade = @"D-";
            currentGradeValue = 0.7;
        }
        else if (grade < 0.60) {
            currentGrade = @"F";
            currentGradeValue = 0.0;
        }
    }
    hasF = NO;
    if (custom) {
        if (grade > [self.aValue doubleValue]*0.01 - 0.01) {
            currentGrade = @"A";
            currentGradeValue = 4;
            
        }
        else if (grade > [self.aMinusValue doubleValue]*0.01 - 0.01){
            currentGrade = @"A-";
            currentGradeValue = 3.7;
        }
        else if (grade > [self.bPlusValue doubleValue]*0.01 - 0.01) {
            currentGrade = @"B+";
            currentGradeValue = 3.3;
        }
        else if (grade > [self.bValue doubleValue]*0.01 - 0.01) {
            currentGrade = @"B";
            currentGradeValue = 3.0;
        }
        else if (grade > [self.bMinusValue doubleValue]*0.01 - 0.01){
            currentGrade = @"B-";
            currentGradeValue = 2.7;
        }
        else if (grade > [self.cPlusValue doubleValue]*0.01 - 0.01) {
            currentGrade = @"C+";
            currentGradeValue = 2.3;
        }
        else if (grade > [self.cValue doubleValue]*0.01 - 0.01) {
            currentGrade = @"C";
            currentGradeValue = 2.0;
        }
        else if (grade > [self.cMinusValue doubleValue]*0.01 - 0.01) {
            currentGrade = @"C-";
            currentGradeValue = 1.7;
        }
        else if (grade > [self.dPlusValue doubleValue]*0.01 - 0.01) {
            currentGrade = @"D+";
            currentGradeValue = 1.3;
        }
        else if (grade > [self.dValue doubleValue]*0.01 - 0.01) {
            currentGrade = @"D";
            currentGradeValue = 1.0;
        }
        else if (grade > [self.dMinusValue doubleValue]*0.01 - 0.01) {
            currentGrade = @"D-";
            currentGradeValue = 0.7;
        }
        else if (grade < [self.dMinusValue doubleValue]*0.01 - 0.01) {
            currentGrade = @"F";
            currentGradeValue = 0;
            hasF = YES;
        }
    
    }
    //Find the course object and update its currentGrade:
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    //TODO: Make sure this actually works
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.courseTitle like %@",self.title];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    //There should only be one thing in the array:
    Course *objectToBeSaved = [array objectAtIndex: 0];
    NSNumber * number = [[NSNumber alloc] initWithDouble:currentGradeValue];
    NSNumber *hasanF = [[NSNumber alloc] initWithBool:hasF];
    [objectToBeSaved setHasF:hasanF];
    
    [objectToBeSaved setCurrentGrade:number];
    
    [self.managedObjectContext save:&error];
    
    [[self.navigationController.viewControllers objectAtIndex:0]
     reloadData];
    
}


@end
