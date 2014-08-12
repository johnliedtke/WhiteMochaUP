//
//  WMEvents.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/7/14.
//
//

#import "WMEvents.h"
#import "WMEvent2.h"
#import "WMEventCell.h"

@interface WMEvents ()

@property (nonatomic, readwrite) NSMutableArray *events; // of WMEvent
@property (nonatomic, readwrite) NSMutableArray *allEvents;
@property (nonatomic, readwrite) NSMutableArray *dates; // of NSString
@property (nonatomic, readwrite) NSMutableDictionary *eventsDictionary;
@property (nonatomic, readwrite) BOOL refresh;

@end

@implementation WMEvents

#pragma mark - Getters

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

# pragma mark - Public

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
        {
            continue;
        }

        // Convert to string
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, MMMM d"];
        NSString *compareDate = [dateFormatter stringFromDate:[evt start]];
        BOOL copy = NO;
        for (NSString *dt in self.dates) {
            if ([dt isEqualToString:compareDate]) {
                copy = YES;
            }
        }
        if (copy) {
            [[self.eventsDictionary objectForKey:compareDate] addObject:evt];
        } else {
            [self.dates addObject:compareDate];
            [self.eventsDictionary setObject:[[NSMutableArray alloc] initWithObjects:evt, nil] forKey:compareDate];
        }
    }

    block(YES);
}

- (void)changeSubCategory:(NSArray *)subCategories
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
        
        if (![subCategories containsObject:evt.subCategory])
        {
            continue;
        }
        
        // Convert to string
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, MMMM d"];
        NSString *compareDate = [dateFormatter stringFromDate:[evt start]];
        BOOL copy = NO;
        for (NSString *dt in self.dates) {
            if ([dt isEqualToString:compareDate]) {
                copy = YES;
            }
        }
        if (copy) {
            [[self.eventsDictionary objectForKey:compareDate] addObject:evt];
        } else {
            [self.dates addObject:compareDate];
            [self.eventsDictionary setObject:[[NSMutableArray alloc] initWithObjects:evt, nil] forKey:compareDate];
        }
    }
    
    block(YES);

}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dates.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section < self.dates.count) {
        return self.dates[section];
    } else {
        return @"";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 25)];
    [view setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 1, tableView.bounds.size.width-15, 20)];

    [label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [label setFont:[UIFont boldSystemFontOfSize:14.0]];
    [label setBackgroundColor:[UIColor clearColor]];
    
    // Title
    if (section < self.dates.count) {
        [label setText:[NSString stringWithFormat:@"%@",self.dates[section]]];
    } else {
        [label setText:@""];
    }
    
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < self.dates.count) {
        return [[self.eventsDictionary objectForKey:self.dates[section]] count];
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Our custom cell!! :D
    WMEventCell *cell = (WMEventCell *)[tableView dequeueReusableCellWithIdentifier:@"WMEventCell"];
    
    WMEvent2 *event = [[self.eventsDictionary objectForKey:self.dates[[indexPath section]]] objectAtIndex:[indexPath row]];
    
    [cell setEvent:event];
    
    return cell;
}



@end
