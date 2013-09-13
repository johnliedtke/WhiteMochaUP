//
//  WMFurniture.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/8/13.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface WMFurniture : NSObject
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



- (id)initWithTitle:(NSString *)itemTitle price:(NSString *)itemPrice description:(NSString *)desc seller:(PFUser *)user image:(PFFile *)imgData location:(NSString *)loc phone:(NSString *)number listDate:(NSDate *)listD;

- (NSDictionary *)dictionary;

@end
