//
//  WMAddPollQuestionViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 11/16/13.
//
//

#import "WMAddPollQuestionViewController.h"

@interface WMAddPollQuestionViewController ()

@end

@implementation WMAddPollQuestionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self navigationItem] setTitle:@"Add Poll"];
    
    
    // Hide the keyboard when pressed outside text field
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(donePressed)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

-(void)donePressed
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)addNewQuestion:(id)sender
{
    if (![[pollQuestion text] isEqualToString:@""]) {
    
    
        // Archive the old poll
        PFQuery *query = [PFQuery queryWithClassName:@"WMPoll"];
        [query whereKey:@"currentPoll" equalTo:[NSNumber numberWithBool:TRUE]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                [object setObject:[NSNumber numberWithBool:FALSE] forKey:@"currentPoll"];
                [object saveInBackground];
            } else {
                NSLog(@"error");
            }
        }];
        
        
        
        // Create a WMRide object!
        PFObject *poll = [PFObject objectWithClassName:@"WMPoll"];
        
        // Add info
        [poll setObject:[NSNumber numberWithBool:TRUE] forKey:@"currentPoll"];
        [poll setObject:[pollQuestion text] forKey:@"poll"];
        [poll setObject:[NSNumber numberWithInt:1] forKey:@"aVotes"];
        [poll setObject:[a text] forKey:@"aVote"];
        [poll setObject:[NSNumber numberWithInt:1] forKey:@"bVotes"];
        [poll setObject:[b text] forKey:@"bVote"];
        [poll setObject:[NSNumber numberWithInt:1] forKey:@"cVotes"];
        [poll setObject:[c text] forKey:@"cVote"];
        [poll setObject:[NSNumber numberWithInt:1] forKey:@"dVotes"];
        [poll setObject:[d text] forKey:@"dVote"];
        
        // Some sexy security
        PFACL *pollACL = [PFACL ACL];
        [pollACL setPublicReadAccess:TRUE];
        [pollACL setPublicWriteAccess:TRUE];
        [poll setACL:pollACL];
        [poll saveInBackground];
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }
    
}
@end
