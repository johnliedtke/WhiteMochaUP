//
//  WMMarketPlaceHomeViewController.m
//  ParseStarterProject
//
//  Created by John Liedtke on 7/7/13.
//
//

#import "WMMarketPlaceHomeViewController.h"
#import "WMGeneralListingViewController.h"
#import "WMFurnitureListingsViewController.h"
#import "WMListingCategoryViewController.h"
#import "WMTextbookSubjects.h"
#import "WMHousingListingsViewController.h"
#import "WMOtherListingsViewController.h"
#import "WMRidesListViewController.h"
#import "WMRidesViewController.h"
#import "WMConstants.h"

@interface WMMarketPlaceHomeViewController ()

@end

@implementation WMMarketPlaceHomeViewController


- (void)list
{
    UIStoryboard *storyEvent = [UIStoryboard storyboardWithName:@"WMListingCatgeoryView" bundle:nil];
    WMListingCategoryViewController *lcvc= [storyEvent instantiateViewControllerWithIdentifier:@"WMListingCatgeoryView"];
    [[self navigationController] pushViewController:lcvc animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *labels = [[NSArray alloc] initWithObjects:furnitureLabel, textbooksLabel, otherLabel, housingLabel, ridesLabel, nil];
    for (UILabel *lab in labels) {
        [lab setFont:[UIFont fontWithName:@"Museo Slab" size:18]];
    }
    
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(list)];
    [[self navigationItem] setRightBarButtonItem:listButton];
    
    // Appearance
    [[self navigationItem] setTitle:@"Marketplace"];
    PURPLEBACK;
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
        [label setFrame:CGRectMake(16, 5, 300, 30)];
        [label setText:@"FOR SALE"];
        return headerView;
    } else {
        [label setFrame:CGRectMake(16, -5, 300, 30)];
        [label setText:@"SERVICES"];
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
        if ([indexPath row] == 0) {
        WMFurnitureListingsViewController *furnitureListingsViewController = [[WMFurnitureListingsViewController alloc] init];
        [[self navigationController] pushViewController:furnitureListingsViewController animated:YES];
        } else if ([indexPath row] == 1) {
            WMTextbookSubjects *tsvc = [[WMTextbookSubjects alloc] init];
            [tsvc setViewType:YES];
            [[self navigationController] pushViewController:tsvc animated:YES];
        } else if ([indexPath row] == 2) {
            WMOtherListingsViewController *otherListingViewController = [[WMOtherListingsViewController alloc] init];
            [[self navigationController] pushViewController:otherListingViewController animated:YES];

        }
    } else if ([indexPath section] == 1) {
        switch ([indexPath row]) {
            case 0: { // Housing
                WMHousingListingsViewController *housingViewController = [[WMHousingListingsViewController alloc] init];
                [[self navigationController] pushViewController:housingViewController animated:YES];
                break;
            }
            case 1: { // Rides
            
                WMRidesListViewController *ridesViewController = [[WMRidesListViewController alloc] init];
                [[self navigationController] pushViewController:ridesViewController animated:YES];
                break;
            }
            default:
                break;
        }

    }
}

@end
