//
//  WMFurnitureCell.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/9/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface WMFurnitureCell : PFTableViewCell
{
    

}

@property (nonatomic, strong) IBOutlet UITextView *title;
@property (nonatomic, strong) IBOutlet UILabel *price;
@property (nonatomic, strong) IBOutlet UILabel *listDate;
@property (nonatomic, strong) IBOutlet PFImageView *furnitureImage;



@end
