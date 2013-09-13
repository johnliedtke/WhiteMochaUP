//
//  WMHousingCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/2/13.
//
//

#import <Foundation/Foundation.h>

@interface WMHousingCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *dateLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *descriptionText;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *locationField;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *itemImage;

@end
