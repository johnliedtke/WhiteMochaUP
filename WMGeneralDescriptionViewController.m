//
//  WMGeneralDescriptionViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/11/13.
//
//

#import "WMGeneralDescriptionViewController.h"
#import "WMConstants.h"

@interface WMGeneralDescriptionViewController ()

@end

@implementation WMGeneralDescriptionViewController

@synthesize text;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [textView setDelegate:self];

        
                                                                                                                                
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [textView setText:[self text]];
    [self setTitle:@"Description"];
    
    
    // Edit
    if ([self doesOwn]) {
        editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editListing)];
        [editButton setTintColor:PURPLECOLOR];
        [[self navigationItem] setRightBarButtonItem:editButton];
       
    }
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Edit crap
- (void)editListing
{
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(doneEditing)];
    [doneButton setTintColor:PURPLECOLOR];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [textView becomeFirstResponder];
    editButton = nil;
    [textView setEditable:YES];

    // Save the current state
    editText = [textView text];
}

- (void)doneEditing
{
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editListing)];
    [editButton setTintColor:PURPLECOLOR];
    [[self navigationItem] setRightBarButtonItem:editButton];
    doneButton = nil;
    
    // Disable again
    [textView setEditable:NO];

    
    // Only save if there were changes
    if (![editText isEqualToString:[textView text]]) {
        [[self generalDescriptionDelegate] updateDescription:[textView text]];
    }
    
}





-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    textView = nil;
    [super viewDidUnload];
}
@end
