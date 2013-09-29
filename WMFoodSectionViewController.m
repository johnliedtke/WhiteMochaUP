//
//  WMFoodSectionViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/30/13.
//
//

#import "WMFoodSectionViewController.h"
#import "WMConstants.h"

@interface WMFoodSectionViewController ()

@end

@implementation WMFoodSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Places to Eat"];
    
    [self setupRefreshControl];
    [self updateHours];

                
}


-(void)updateHours
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMFoodHours"];
    
    [query getObjectInBackgroundWithId:@"XigEyM87u0" block:^(PFObject *object, NSError *error) {
        hours = object;
        // Commons
        [commonsMonThurs setText:[hours objectForKey:@"commonsMonThurs"]];
        [comMonThuHours setText:[hours objectForKey:@"comMonThuHours"]];
        [comFriday setText:[hours objectForKey:@"comFriday"]];
        [comFriHours setText:[hours objectForKey:@"comFriHours"]];
        [comSaturday setText:[hours objectForKey:@"comSaturday"]];
        [comSaturdayHours setText:[hours objectForKey:@"comSaturdayHours"]];
        [comSunday setText:[hours objectForKey:@"comSunday"]];
        [comSunHours setText:[hours objectForKey:@"comSunHours"]];
        
        // Cove
        [coveMonThuHours setText:[hours objectForKey:@"coveMonThuHours"]];
        [coveMonThurs setText:[hours objectForKey:@"coveMonThurs"]];
        [coveFridaySaturday setText:[hours objectForKey:@"coveFridaySaturday"]];
        [coveFriSatHours setText:[hours objectForKey:@"coveFriSatHours"]];
        [coveSatSun setText:[hours objectForKey:@"coveSatSun"]];
        [coveSatSunHours setText:[hours objectForKey:@"coveSatSunHours"]];
        
        // Anchor
        [anchorHours setText:[hours objectForKey:@"anchorHours"]];
        [refreshControl endRefreshing];
        [[self tableView] reloadData];
    }];
    
    

}

-(void)setupRefreshControl
{
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateHours) forControlEvents:UIControlEventValueChanged];
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    //[refreshControl setTintColor:PURPLECOLOR];
    [self setRefreshControl:refreshControl];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
