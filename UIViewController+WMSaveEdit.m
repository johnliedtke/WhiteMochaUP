//
//  UIViewController+WMSaveEdit.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/2/14.
//
//

#import "UIViewController+WMSaveEdit.h"

@implementation UIViewController (WMSaveEdit)

- (void)addEditButton
{
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPushed:)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)addSaveButton
{
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPushed:)];
    self.navigationItem.rightBarButtonItem = saveButton;

}

- (void)editButtonPushed:(id)sender
{
    [self addSaveButton];
    if ([self respondsToSelector:@selector(edit)]) {
        [self performSelector:@selector(edit)];
    }
}

- (void)saveButtonPushed:(id)sender
{
    [self addEditButton];

    if ([self respondsToSelector:@selector(save)]) {
        [self performSelector:@selector(save)];
    }
}

@end
