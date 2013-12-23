//
//  WMPlaceItem.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/21/13.
//
//  Used for the PlaceInfo class

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface WMPlaceItem : PFObject<PFSubclassing>

// Descriptive title for the info item
@property (nonatomic, copy, readonly) NSString *itemTitle;

// Value for the info item
@property (nonatomic, copy) NSString *itemContents;

// Designated Initializer
- (id)initWithTitle:(NSString *)title contents:(NSString *)content;

// Set the class name for Parse
+ (NSString *)parseClassName;

@end
