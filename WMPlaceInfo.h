//
//  WMPlaceInfo.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/20/13.
//
//  Extra information about the place

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@class WMPlaceItem;

@interface WMPlaceInfo : PFObject<PFSubclassing>

// Link to the place's online menu
@property (nonatomic, strong) WMPlaceItem *menuLink;
// Hours
@property (nonatomic, strong) WMPlaceItem *hours;
// Place website
@property (nonatomic, strong) WMPlaceItem *website;
// Pilot Must go
@property (nonatomic, readonly) WMPlaceItem *pilotMustGo;
// Takes reservations?
@property (nonatomic, strong) WMPlaceItem *reservations;
// Takes delivery?
@property (nonatomic, strong) WMPlaceItem *delivery;
// Take-out available?
@property (nonatomic, strong) WMPlaceItem *takeOut;
// Noise level
@property (nonatomic, strong) WMPlaceItem *noiseLevel;
// Suggested attire
@property (nonatomic, strong) WMPlaceItem *attire;
// Good for groups
@property (nonatomic, strong) WMPlaceItem *groups;
// Accepts credit cards?
@property (nonatomic, strong) WMPlaceItem *creditCards;
// What kind of parking?
@property (nonatomic, strong) WMPlaceItem *parking;
// Waiter service?
@property (nonatomic, strong) WMPlaceItem *waiterService;
// Alochol?
@property (nonatomic, strong) WMPlaceItem *alcohol;
// Wheelchair accessible?
@property (nonatomic, strong) WMPlaceItem *wheelchair;
// Gots a tv?
@property (nonatomic, strong) WMPlaceItem *tv;

// The array that contains all/Users/John/Dropbox/WhiteMochaUP/WMPlaceInfo.h of these bad boys
@property (nonatomic, strong) NSArray *infoItems;


// Default Value Initializer
- (id)initWithDefaults;





// Set the class name for Parse
+ (NSString *)parseClassName;

@end
