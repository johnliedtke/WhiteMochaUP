//
//  WMAddGradingScaleViewController.h
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 11/16/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "WMAddSyllabusFormViewController.h"

@interface WMAddGradingScaleViewController : UITableViewController<UITextFieldDelegate>
{
    NSString *aValue_;
    NSString *aMinusValue_;
    NSString *bPlusValue_;
    NSString *bValue_;
    NSString *bMinusValue_;
    NSString *cPlusValue_;
    NSString *cValue_;
    NSString *cMinusValue_;
    NSString *dPlusValue_;
    NSString *dValue_;
    NSString *dMinusValue_;
    
    
    UITextField *aValueField_;
    UITextField *aMinusField_;
    UITextField *bPlusField_;
    UITextField *bField_;
    UITextField *bMinusField_;
    UITextField *cPlusField_;
    UITextField *cField_;
    UITextField *cMinusField_;
    UITextField *dPlusField_;
    UITextField *dField_;
    UITextField *dMinusField_;
    

}

@property (nonatomic, copy) NSString *aValue;
@property (nonatomic, copy) NSString *aMinusValue;
@property (nonatomic, copy) NSString *bPlusValue;
@property (nonatomic, copy) NSString *bValue;
@property (nonatomic, copy) NSString *bMinusValue;
@property (nonatomic, copy) NSString *cPlusValue;
@property (nonatomic, copy) NSString *cValue;
@property (nonatomic, copy) NSString *cMinusValue;
@property (nonatomic, copy) NSString *dPlusValue;
@property (nonatomic, copy) NSString *dValue;
@property (nonatomic, copy) NSString *dMinusValue;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSString *courseTitle;




@end
