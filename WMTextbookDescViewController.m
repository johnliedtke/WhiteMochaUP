//
//  WMTextbookDescViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/31/13.
//
//

#import "WMTextbookDescViewController.h"
#import "WMTextbookDescCell.h"
#import "WMTextbookTextCell.h"

@interface WMTextbookDescViewController ()

@end

@implementation WMTextbookDescViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        [[self navigationItem] setRightBarButtonItem:done];
        [self setTitle:@"Description"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Reigster the nib
    [[self tableView] registerNib:[UINib nibWithNibName:@"WMTextbookDescCell" bundle:nil]
           forCellReuseIdentifier:@"texbookDescCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"WMTextbookTextCell" bundle:nil]
           forCellReuseIdentifier:@"textbookTextCell"];
    
    [self setEdition:[[self savedInfo] objectForKey:@"edition"]];
    [self setISBN:[[self savedInfo] objectForKey:@"ISBN"]];
    [self setText:[[self savedInfo] objectForKey:@"text"]];
    
    // Hide the keyboard when pressed outside text field
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done
{
    [self hideKeyboard];
    NSString *theText = [self text];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                theText, @"text",
                                [self edition], @"edition",
                                [self ISBN], @"ISBN",
                                nil];
    [[self descriptionDelegate] descriptionType:dictionary];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return !([indexPath section]) ? 88: 175;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == [detailCell editionField]) {
        [self setEdition:[[detailCell editionField] text]];
    } else {
        [self setISBN:[[detailCell ISBNField] text]];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self setText:[textView text]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return !(section) ? @"Textbook Details" : @"Description";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%d",(arc4random() %1000)]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }

    if ([indexPath section] == 0) {
        detailCell = (WMTextbookDescCell *)[tableView dequeueReusableCellWithIdentifier:@"texbookDescCell"];
        [[detailCell editionField] setText:[self edition]];
        [[detailCell ISBNField] setText:[self ISBN]];
        [[detailCell editionField] setDelegate:self];
        [[detailCell ISBNField] setDelegate:self];
        
        return detailCell;

    } else if ([indexPath section] == 1) {
        textCell = (WMTextbookTextCell *)[tableView dequeueReusableCellWithIdentifier:@"textbookTextCell"];
        [[textCell descTextView] setDelegate:self];
        [[textCell descTextView] setText:[self text]];
        return textCell;
        
    }
    

    
    return cell;
}

/* Limit the number of characters for different fields */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [[textField text] length] + [string length] - range.length;
    if (textField == [detailCell ISBNField]) {
        return !(newLength > 30);
    } else if (textField == [detailCell editionField]) {
        NSCharacterSet *myCharset = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            return ([myCharset characterIsMember:c] && !(newLength > 3));
        }
    }
    
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

@end
