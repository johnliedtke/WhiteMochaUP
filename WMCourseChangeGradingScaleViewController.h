//
//  WMCourseChangeGradingScaleViewController.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 8/17/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Course.h"
#import "WMPrevNext.h"

@interface WMCourseChangeGradingScaleViewController : UITableViewController <UITextFieldDelegate, WMPrevNextDelegate>{
    NSString *AValue_;
    NSString *AMinusValue_;
    NSString *BPlusValue_;
    NSString *BValue_;
    NSString *BMinusValue_;
    NSString *CPlusValue_;
    NSString *CValue_;
    NSString *CMinusValue_;
    NSString *DPlusValue_;
    NSString *DValue_;
    NSString *DMinusValue_;
    //NSString *FValue_;
    
    UITextField *AValueField_;
    UITextField *AMinusValueField_;
    UITextField *BPlusValueField_;
    UITextField *BValueField_;
    UITextField *BMinusValueField_;
    UITextField *CPlusValueField_;
    UITextField *CValueField_;
    UITextField *CMinusValueField_;
    UITextField *DPlusValueField_;
    UITextField *DValueField_;
    UITextField *DMinusValueField_;
    //UITextField *FValueField_;
    WMPrevNext *prevNext;
}

-(UITextField*) makeTextField:(NSString*)text
                  placeholder: (NSString*)placeholder;
- (IBAction)textFieldFinished:(id)sender;

@property (nonatomic, strong) NSString *AValue;
@property (nonatomic, strong) NSString *AMinusValue;
@property (nonatomic, strong) NSString *BPlusValue;
@property (nonatomic, strong) NSString *BValue;
@property (nonatomic, strong) NSString *BMinusValue;
@property (nonatomic, strong) NSString *CPlusValue;
@property (nonatomic, strong) NSString *CValue;
@property (nonatomic, strong) NSString *CMinusValue;
@property (nonatomic, strong) NSString *DPlusValue;
@property (nonatomic, strong) NSString *DValue;
@property (nonatomic, strong) NSString *DMinusValue;
//@property (nonatomic, strong) NSString *FValue;



@property (nonatomic, strong) NSString * courseTitle;
//For core data:
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
