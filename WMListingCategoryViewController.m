//
//  WMListingCategoryViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/29/13.
//
//

#import "WMListingCategoryViewController.h"
#import "WMGeneralListingViewController.h"
#import "WMTextbookSubjects.h"
#import "WMRidesViewController.h"
#import "WMConstants.h"

@interface WMListingCategoryViewController ()

@end

@implementation WMListingCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *labels = [[NSArray alloc] initWithObjects:furnitureLabel, textbookLabel, otherLabel, housingLabel, ridesLabel, nil];
    for (UILabel *lab in labels) {
        [lab setFont:[UIFont fontWithName:@"Museo Slab" size:18]];
    }
    sales = [NSArray arrayWithObjects:@"Furniture", @"Textbooks", @"Other", nil];
    services = [NSArray arrayWithObjects:@"Housing", @"Rides", @"Other", nil];
    categories = [NSArray arrayWithObjects:sales, services, nil];
    PURPLEBACK
    [self setTitle:@"Marketplace"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
    [headerView addSubview:label];
    [label setFont:[UIFont fontWithName:@"Museo Slab" size:17]];
    [label setBackgroundColor:[UIColor clearColor]];
    
    if (section == 0) {
        [label setFrame:CGRectMake(15, 5, 300, 30)];
        [label setText:@"SELL SOMETHING"];
        return headerView;
    } else {
        [label setFrame:CGRectMake(15, -5, 300, 30)];
        [label setText:@"OFFER A SERVICE"];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }
    return (section == 0 || section == 1) ? 30 : UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) return 25;
    else return 10;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        switch ([indexPath row]) {
            case 0: // Furniture
            {
                WMGeneralListingViewController *lfvc = [[WMGeneralListingViewController alloc] init];
                NSMutableDictionary *listingInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                    @"furniture", @"listingType",
                                                    nil];
                [lfvc setListingType:listingInfo];
                [[self navigationController] pushViewController:lfvc animated:YES];
                break;
            }
                case 1:
            {
                WMTextbookSubjects *tbvc = [[WMTextbookSubjects alloc] init];
                [[self navigationController] pushViewController:tbvc animated:YES];
                break;
            }
            case 2: {
                WMGeneralListingViewController *lfvc = [[WMGeneralListingViewController alloc] init];
                NSMutableDictionary *listingInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                    @"other", @"listingType",
                                                    nil];
                [lfvc setListingType:listingInfo];
                [[self navigationController] pushViewController:lfvc animated:YES];
                break;
            }
            default:
                break;
        }

    } else if ([indexPath section] == 1) {
        switch ([indexPath row]) {
            case 0: {
                WMGeneralListingViewController *lfvc = [[WMGeneralListingViewController alloc] init];
                NSMutableDictionary *listingInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                    @"housing", @"listingType",
                                                    nil];
                [lfvc setListingType:listingInfo];
                [[self navigationController] pushViewController:lfvc animated:YES];
                 break;
            } case 1: {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"WMRides" bundle:nil];
                WMRidesViewController *meow = [story instantiateViewControllerWithIdentifier:@"WMRides"];
                [[self navigationController] pushViewController:meow animated:YES];
            }
                
            default:
                break;
        }
    }
}

@end
