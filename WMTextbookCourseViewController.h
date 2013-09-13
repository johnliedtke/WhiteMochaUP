//
//  WMTextbookCourseViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/30/13.
//
//

#import <UIKit/UIKit.h>



@interface WMTextbookCourseViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *courses;
    NSArray *levels;
}

@property (nonatomic, unsafe_unretained) NSArray *subjects;
@property (nonatomic, strong) NSString *subject;

@property (nonatomic) BOOL viewType;


// Delegate
//@property (nonatomic, unsafe_unretained) id <WMListingTypeDelegate> textbookDelegate;

@end
