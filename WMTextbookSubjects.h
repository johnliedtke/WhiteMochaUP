//
//  WMTextBooksViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/27/13.
//
//

#import <UIKit/UIKit.h>

@interface WMTextbookSubjects : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *titles;
    NSArray *subjects;
    NSMutableDictionary *dictionary;
}

@property (nonatomic) BOOL viewType;



@end
