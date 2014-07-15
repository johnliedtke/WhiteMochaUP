//
//  WMEvents.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/7/14.
//
//

#import "WMEvents.h"
#import "WMEvent2.h"

@interface WMEvents ()

@property (nonatomic, readwrite) NSMutableArray *events; // of WMEvent
@property (nonatomic, readwrite) NSMutableArray *allEvents;
@property (nonatomic, readwrite) NSMutableArray *dates; // of NSString
@property (nonatomic, readwrite) NSMutableDictionary *eventsDictionary;
@property (nonatomic, readwrite) BOOL refresh;



@end

@implementation WMEvents

- (NSMutableArray *)events
{
    if (!_events) _events = [[NSMutableArray alloc] init];
    return _events;
}

- (NSMutableArray *)dates
{
    if (!_dates) _dates = [[NSMutableArray alloc] init];
    return _dates;
}

- (NSMutableArray *)allEvents
{
    if (!_allEvents) _allEvents = [NSMutableArray array];
    return _allEvents;
}

- (NSMutableDictionary *)eventsDictionary
{
    if (!_eventsDictionary) _eventsDictionary = [[NSMutableDictionary alloc] init];
    return _eventsDictionary;
}

- (void)addEvents:(NSArray *)events
{
    [self.events removeAllObjects];
    [self.events addObjectsFromArray:events];
}

- (void)changeCategory:(NSString *)category
        withBlock:(WMChaneEventsCompletionBlock)block
{
    // Clean events
    [self.dates removeAllObjects];
    [self.eventsDictionary removeAllObjects];
    
    // Sort events by date
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [self.events sortUsingDescriptors:sortDescriptors];
    
    
    // Sort dates...
    for (WMEvent2 *evt in self.events) {
        
        if (![evt.category isEqualToString:category] && ![category isEqualToString:ALL_CATEGORY])
                continue;


        
        // Make them strings...
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, MMMM d"];
        NSString *compareDate = [dateFormatter stringFromDate:[evt start]];
        BOOL copy = NO;
        for (NSString *dt in self.dates) {
            if ([dt isEqualToString:compareDate]) {
                copy = YES;
            }
        }
        if (!copy) {
            [self.dates addObject:compareDate];
            [self.eventsDictionary setObject:[[NSMutableArray alloc] initWithObjects:evt, nil] forKey:compareDate];
        } else {
            [[self.eventsDictionary objectForKey:compareDate] addObject:evt];
        }
    }

    block(YES);
}

- (BOOL)isClubsCategory:(NSString *)event
{
    return [event isEqualToString:CLUBS_CATEGORY];
}

- (BOOL)isSportsCategory:(NSString *)event
{
    return [event isEqualToString:SPORTS_CATEGORY];
}

- (BOOL)isSchoolCategory:(NSString *)event
{
    return [event isEqualToString:SCHOOL_CATEGORY];
}


@end
