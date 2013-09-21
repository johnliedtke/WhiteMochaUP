//
//  WMTextbookCourseViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/30/13.
//
//

#import "WMGeneralListingViewController.h"
#import "WMTextbookCourseViewController.h"
#import "WMTextbookListingsViewController.h"
#import "WMConstants.h"


@interface WMTextbookCourseViewController ()

@end

@implementation WMTextbookCourseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        // Find out the path of recipes.plist
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Subjects" ofType:@"plist"];
        
        // Load the file content and read the data into array
        levels = [[NSMutableArray alloc] init];
        levelNumbers = [[NSMutableArray alloc] init];
    
        courses = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        
       // Appearance
        PURPLEBACK
        [self setTitle:@"Marketplace"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@ <---", [self subject]);
    
    
    
    //[[sortedLevels objectAtIndex:[indexPath row]] objectAtIndex:0]]
    selectedCourses = [courses objectForKey:[self subject]];
    for (int i =1; i <= 5; i++) {
        NSArray *testArray = [self sortedLevels:i];
        if ([testArray count] > 0) {
            NSString *levelString = [NSString stringWithFormat:@"%d00", i];
            [levels addObject:levelString];
            NSNumber  *number = [NSNumber numberWithInt:i];
            [levelNumbers addObject:number];
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
    return [levels count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *sortedLevels = [self sortedLevels:[levelNumbers[section] intValue]];
    
    return [sortedLevels count];
}

// Returns an array with the specified level
- (NSArray *)sortedLevels:(int)level
{
    NSString *pricePattern = @"(?:^[a-z]{1,4}\\s)";
    NSError *error = NULL;
    NSMutableArray *sortedLevels = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[courses objectForKey:[self subject]] count]; i++) {
        NSString *course = selectedCourses[i][0];
        NSRange stringRange = NSMakeRange(0, course.length);
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pricePattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSString *numberString = [regex stringByReplacingMatchesInString:course options:NSMatchingReportProgress range:stringRange withTemplate:@"$1"];
        NSString *trimmed = [numberString substringToIndex:1];
        int number = [trimmed intValue];
        if (level == number) [sortedLevels addObject:selectedCourses[i]];
    }
    return sortedLevels;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return levels;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return levels[section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }

    NSArray *sortedLevels = [self sortedLevels:[levelNumbers[[indexPath section]] intValue]];
    [[cell textLabel] setText:[[sortedLevels objectAtIndex:[indexPath row]] objectAtIndex:0]];
    [[cell detailTextLabel] setText:[[sortedLevels objectAtIndex:[indexPath row]] objectAtIndex:1]];
    
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *courseInfo = [courses objectForKey:[self subject]];
    NSMutableDictionary *listingInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 @"textbook", @"listingType",
                                 [self subject], @"subject",
                                 [[courseInfo objectAtIndex:[indexPath row]]objectAtIndex:0], @"course",
                                 nil];
    if ([self viewType]) {
        WMTextbookListingsViewController *textbookListings = [[WMTextbookListingsViewController alloc] init];
        [textbookListings setCourseInfo:listingInfo];
        [[self navigationController] pushViewController:textbookListings animated:YES];
        
    } else {
        WMGeneralListingViewController *glvc = [[WMGeneralListingViewController alloc] init];
        [glvc setListingType:listingInfo];
        [[self navigationController] pushViewController:glvc animated:YES];
    }

}

@end
