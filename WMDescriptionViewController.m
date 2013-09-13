//
//  WMDescriptionViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/7/13.
//
//

#import "WMDescriptionViewController.h"

@interface WMDescriptionViewController ()

@end

@implementation WMDescriptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [descriptionView setDelegate:self];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(done)];
        [[self navigationItem] setRightBarButtonItem:done];
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                  action:@selector(cancelEditing)];
        [[self navigationItem] setLeftBarButtonItem:cancel];
        
    }
    return self;
}

- (void)done
{
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[descriptionView text], @"text", nil];
    [[self descriptionDelegate] descriptionType:dictionary];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)cancelEditing
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [descriptionView setText:[self defaultText]];
    [descriptionView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    descriptionView = nil;
    [super viewDidUnload];
}
@end
