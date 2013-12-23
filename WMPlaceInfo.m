//
//  WMPlaceInfo.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/20/13.
//
//

#import "WMPlaceInfo.h"
#import <Parse/PFObject+Subclass.h>
#import "WMPlaceItem.h"

@interface WMPlaceInfo ()
@property (nonatomic, readwrite) WMPlaceItem *pilotMustGo;
@end

@implementation WMPlaceInfo
@dynamic menuLink, hours, website, reservations, delivery, takeOut, noiseLevel, attire, groups, creditCards, parking, waiterService, alcohol, wheelchair, tv, pilotMustGo, infoItems;


- (id)initWithDefaults
{
    if (self = [super init]) {
       // WMPlaceItem *item = [[WMPlaceItem alloc] initWithTitle:@"Menu Website" contents:@"N/A"];
        [self setMenuLink:[[WMPlaceItem alloc] initWithTitle:@"Menu Website" contents:@"N/A"]];
        [self setHours:[[WMPlaceItem alloc] initWithTitle:@"Hours" contents:@"N/A"]];
        [self setWebsite:[[WMPlaceItem alloc] initWithTitle:@"Website" contents:@"N/A"]];
        [self setReservations:[[WMPlaceItem alloc] initWithTitle:@"Takes Reservations" contents:@"N/A"]];
        [self setDelivery:[[WMPlaceItem alloc] initWithTitle:@"Delivery" contents:@"N/A"]];
        [self setPilotMustGo:[[WMPlaceItem alloc] initWithTitle:@"Pilot Must Go" contents:@"N/A"]];
        [self setTakeOut:[[WMPlaceItem alloc] initWithTitle:@"Take-out" contents:@"N/A"]];
        [self setNoiseLevel:[[WMPlaceItem alloc] initWithTitle:@"Noise Level" contents:@"N/A"]];
        [self setAttire:[[WMPlaceItem alloc] initWithTitle:@"Suggested Attire" contents:@"N/A"]];
        [self setGroups:[[WMPlaceItem alloc] initWithTitle:@"Good for Groups" contents:@"N/A"]];
        [self setCreditCards:[[WMPlaceItem alloc] initWithTitle:@"Accepts Credit Cards" contents:@"N/A"]];
        [self setParking:[[WMPlaceItem alloc] initWithTitle:@"Parking" contents:@"N/A"]];
        [self setWaiterService:[[WMPlaceItem alloc] initWithTitle:@"Waiter Service" contents:@"N/A"]];
        [self setAlcohol:[[WMPlaceItem alloc] initWithTitle:@"Alocohol" contents:@"N/A"]];
        [self setWheelchair:[[WMPlaceItem alloc] initWithTitle:@"Wheelchair Accessible" contents:@"N/A"]];
        [self setTv:[[WMPlaceItem alloc] initWithTitle:@"Has TV" contents:@"N/A"]];
        // Set the rest of these bitches later.
        NSArray *items = [[NSArray alloc] initWithObjects:[self menuLink],[self hours], [self website], [self reservations], [self delivery], [self pilotMustGo], [self takeOut], [self noiseLevel], [self attire], [self groups], [self creditCards], [self parking], [self waiterService], [self alcohol], [self wheelchair], [self tv], nil];
        [self setInfoItems:items];
    }
    return self;
}

+ (NSString *)parseClassName
{
    return @"WMPlaceInfo";
}

@end
