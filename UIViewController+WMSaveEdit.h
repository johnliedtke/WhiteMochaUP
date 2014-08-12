//
//  UIViewController+WMSaveEdit.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/2/14.
//
//

#import <UIKit/UIKit.h>


@protocol WMEditSaveDelegate <NSObject>

- (void)save;
- (void)edit;

@end

@interface UIViewController (WMSaveEdit)

- (void)addEditButton;
- (void)addSaveButton;

@end
