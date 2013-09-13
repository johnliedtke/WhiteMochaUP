//
//  WMGeneralListing.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/27/13.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface WMGeneralListing : NSObject
{
    NSDictionary *dictionary;
}



@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSString *price;
@property (nonatomic, strong) PFUser *seller;
@property (nonatomic, strong) PFFile *imageData;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *descriptionOfItem;
@property (nonatomic, copy) NSDate *listDate;
@property (nonatomic, strong) NSString *phone;


- (NSDictionary *)dictionary;

- (id)initWithTitle:(NSString *)itemTitle price:(NSString *)itemPrice description:(NSString *)desc seller:(PFUser *)user image:(PFFile *)imgData location:(NSString *)loc phone:(NSString *)number listDate:(NSDate *)listD;


@end
