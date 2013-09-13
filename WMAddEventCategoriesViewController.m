//
//  WMAddEventCategoriesViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/18/13.
//
//

#import "WMAddEventCategoriesViewController.h"
#import "WMClubFormViewController.h"
#import "WMAddEventFormViewController.h"

@interface WMAddEventCategoriesViewController ()

@end

@implementation WMAddEventCategoriesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setTitle:@"Add Event"];
    
    NSArray *labels = [[NSArray alloc] initWithObjects:academicLabel, funLabel, clubsLabel, sportsLabel, nil];
    for (UILabel *label in labels) {
        [label setFont:[UIFont fontWithName:@"Museo Slab" size:18]];
    }
    
    [academicImageView setImage:[UIImage imageNamed:@"academic.png"]];
    
    // Appearance
    PURPLEBACK

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *viewControllerStack = [[self navigationController] viewControllers];
    UIStoryboard *storyEvent = [UIStoryboard storyboardWithName:@"WMAddEventForm" bundle:nil];
    WMAddEventFormViewController *addEventViewController = [storyEvent instantiateViewControllerWithIdentifier:@"WMAddEventForm"];
    [addEventViewController setAddEventDelegate:viewControllerStack[0]];
    switch ([indexPath row]) {
        case 0: {
            [addEventViewController setEventType:ACADEMICS];
            [[self navigationController] pushViewController:addEventViewController animated:YES];
            break;
        }
        case 1: {
            storyEvent = nil;
            addEventViewController = nil;
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"WMClubForm" bundle:nil];
            WMClubFormViewController *clubFormViewController = [story instantiateViewControllerWithIdentifier:@"WMClubForm"];
            [clubFormViewController setAddEventDelegate:viewControllerStack[0]];
            [[self navigationController] pushViewController:clubFormViewController animated:YES];
            break;
        }
        case 2: {
            [addEventViewController setEventType:FUN];
            [[self navigationController] pushViewController:addEventViewController animated:YES];
            break;
        }
        case 3: {
            [addEventViewController setEventType:SPORTS];
            [[self navigationController] pushViewController:addEventViewController animated:YES];
            break;
        }
    }

}

@end
