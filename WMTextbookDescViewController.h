//
//  WMTextbookDescViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/31/13.
//
//

#import <UIKit/UIKit.h>
@class WMTextbookDescCell, WMTextbookTextCell;
#import "WMDescriptionDelegate.h"

@interface WMTextbookDescViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    WMTextbookDescCell *detailCell;
    WMTextbookTextCell *textCell;
}


@property (nonatomic, strong) NSMutableDictionary *savedInfo;
@property (nonatomic, strong) NSString *edition;
@property (nonatomic, strong) NSString *ISBN;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, unsafe_unretained) id <WMDescriptionDelegate> descriptionDelegate;


@end
