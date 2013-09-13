//
//  WMRidesCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/10/13.
//
//

#import <Foundation/Foundation.h>

@interface WMRidesCell : UITableViewCell
{
    
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *toLabel;
    __weak IBOutlet UILabel *fromLabel;
}

@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
