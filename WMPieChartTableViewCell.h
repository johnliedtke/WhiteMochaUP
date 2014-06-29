//
//  WMPieChartTableViewCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/7/14.
//
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface WMPieChartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@property (strong, nonatomic) NSString *test;

@end
