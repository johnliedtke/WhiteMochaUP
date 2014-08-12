//
//  WMAddEventViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/11/14.
//
//

#import "WMAddEventViewController.h"
#import "UIFont+FlatUI.h"
#import "UIColor+WMColors.h"

@interface WMAddEventViewController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *views;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *fields;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *createEventLabel;

@end

@implementation WMAddEventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor WMBackgroundColor];
    for (UIView *v in self.views) {
        v.layer.cornerRadius = 5.0;
        v.clipsToBounds = YES;
        v.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:254./255.0 blue:254./255.0 alpha:1.0];
        v.layer.borderWidth = 1.0;
        v.layer.borderColor = [UIColor WMBorderColor].CGColor;
    }
    for (UILabel *l in self.labels) {
        [l setFont:[UIFont flatFontOfSize:17.0]];
        //[l setTextColor:[UIColor WMPurpleColor]];

    }
    for (UITextField *tf in self.fields) {
        [tf setTextColor:[UIColor darkGrayColor]];
        [tf setFont:[UIFont flatFontOfSize:16.0]];
       // tf.attributedPlaceholder =
        //[[NSAttributedString alloc]
//         initWithString:@"e.g. Example Event"
//         attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];

    }
    [_createEventLabel setFont:[UIFont flatFontOfSize:17.0]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
