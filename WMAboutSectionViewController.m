//
//  WMAboutSectionViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 9/1/13.
//
//

#import "WMAboutSectionViewController.h"
#import <Parse/Parse.h>

@interface WMAboutSectionViewController ()

@end

@implementation WMAboutSectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"About"];
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





- (IBAction)logOut:(id)sender
{
    [PFUser logOut];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}
@end
