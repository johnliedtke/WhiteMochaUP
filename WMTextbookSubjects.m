//
//  WMTextBooksViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/27/13.
//
//

#import "WMTextbookSubjects.h"
#import "WMTextbookCourseViewController.h"
#import "WMConstants.h"

@interface WMTextbookSubjects ()

@end

@implementation WMTextbookSubjects

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        titles = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"M", @"N", @"P", @"R", @"S", @"T", nil];
        subjects = [NSArray arrayWithObjects:@"Aerospace Studies", @"Biology", @"Business Administration", @"Chemistry", @"Chinese", @"Civil Engineering", @"Communication Studies", @"Chinese", @"Civil Engineering", @"Computer Science", @"Dance", @"Drama", @"Economics", @"Education", @"Electrical Engineering", @"English", @"Environmental Studies", @"Fine Arts", @"French", @"German", @"History", @"Mathematics", @"Mechanical Engineering", @"Music", @"Nursing", @"Philosphy", @"Physics", @"Political Science", @"Psychology", @"Religious Studies", @"Social Work", @"Sociology", @"Spanish", @"Theological Perspectives", @"Theology", nil];
        
        dictionary = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < [titles count]; i++) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@",titles[i]];
            NSArray *objects = [subjects filteredArrayUsingPredicate:predicate];
            [dictionary setObject:objects forKey:[titles objectAtIndex:i]];
            
        }
        
        
        
        
  
        
        // Appearance
        PURPLEBACK
        [self setTitle:@"Marketplace"];
        
    }
        
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return [titles count];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return titles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@",titles[section]];
    NSArray *numRows = [subjects filteredArrayUsingPredicate:predicate];
    return [numRows count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return titles;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@",titles[[indexPath section]]];
    NSArray *filteredSubjects = [subjects filteredArrayUsingPredicate:predicate];
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@",filteredSubjects[[indexPath row]]]];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMTextbookCourseViewController *tcvc = [[WMTextbookCourseViewController alloc] init];
    [tcvc setViewType:[self viewType]];
 
    NSArray *selectedCourses = [dictionary objectForKey:[titles objectAtIndex:[indexPath section]]];
    [tcvc setSubject:[selectedCourses objectAtIndex:[indexPath row]]];
    [[self navigationController] pushViewController:tcvc animated:YES];
}

@end
