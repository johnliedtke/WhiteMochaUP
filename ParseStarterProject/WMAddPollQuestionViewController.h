//
//  WMAddPollQuestionViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 11/16/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface WMAddPollQuestionViewController : UITableViewController
{
    IBOutlet UITextField *pollQuestion;
   
    IBOutlet UITextField *a;
    IBOutlet UITextField *b;
    
    IBOutlet UITextField *d;
    IBOutlet UITextField *c;
}
- (IBAction)addNewQuestion:(id)sender;

@end
