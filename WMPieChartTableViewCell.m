//
//  WMPieChartTableViewCell.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/7/14.
//
//

#import "WMPieChartTableViewCell.h"


@implementation WMPieChartTableViewCell
//@synthesize pieChart;

- (void)awakeFromNib
{
    // Initialization code
    
//    [self.pieChart setDelegate:self];
//    [self.pieChart setDataSource:self];
//    [self.pieChartRight setPieCenter:CGPointMake(240, 240)];
//    [self.pieChartRight setShowPercentage:NO];
    [self.pieChart setLabelColor:[UIColor whiteColor]];
    [self.pieChart setShowPercentage:YES];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
