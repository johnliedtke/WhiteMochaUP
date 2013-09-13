//
//  WMFurnitureDetailCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/27/13.
//
//

#import <Foundation/Foundation.h>

@interface WMFurnitureDetailCell : UITableViewCell
{
    
}
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *priceField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *sellerField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *locationField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *listedField;

@end
