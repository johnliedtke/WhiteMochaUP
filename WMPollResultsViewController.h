//
//  WMPollResultsViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/7/14.
//
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "WMPoll.h"
#import "WMCommentsHeaderTableViewCell.h"
#import "WMCommentTextViewBar.h"
#import "WMCommentBar.h"

@interface WMPollResultsViewController : UITableViewController <XYPieChartDelegate, XYPieChartDataSource, UIToolbarDelegate, UITableViewDelegate, WMCommentsHeaderDelegate, WMCommentBarDelegate>

@property (nonatomic, strong) WMPoll *poll;
@property (nonatomic, strong) XYPieChart *pieChart;

@end
