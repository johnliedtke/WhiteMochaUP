//
//  WMFurniture.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/8/13.
//
//

#import "WMFurniture.h"

@implementation WMFurniture

@synthesize title, price, descriptionOfItem, seller, imageData, location, listDate, phone;

- (id)initWithTitle:(NSString *)itemTitle price:(NSString *)itemPrice description:(NSString *)desc seller:(PFUser *)user image:(PFFile *)imgData location:(NSString *)loc phone:(NSString *)number listDate:(NSDate *)listD
{
    self = [super init];
    if (self) {
        [self setTitle:itemTitle];
        [self setPrice:itemPrice];
        [self setDescriptionOfItem:desc];
        [self setSeller:user];
        [self setImageData:imgData];
        [self setLocation:loc];
        [self setListDate:listD];
        [self setPhone:number];
    }
    return self;
}

-(NSDictionary *)dictionary
{
    dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
              [self title], @"title",
              [self price], @"price",
              [self descriptionOfItem], @"itemDescription",
              [self seller], @"seller",
              [self imageData], @"imageData",
              [self location], @"location",
              [self listDate], @"listDate",
              [self phone], @"phone",
              nil];
    return dictionary;
}

@end
