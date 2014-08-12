//
//  WMEvents.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/7/14.
//
//

#import <Foundation/Foundation.h>

typedef void (^WMChaneEventsCompletionBlock)(BOOL success);
@interface WMEvents : NSObject <UITableViewDataSource>

@property (nonatomic, readonly) NSMutableArray *events; // of WMEvent
@property (nonatomic, readonly) NSMutableArray *dates;
@property (nonatomic, readonly) NSMutableDictionary *eventsDictionary;

- (void)addEvents:(NSArray *)events;
- (void)changeCategory:(NSString *)category
             withBlock:(WMChaneEventsCompletionBlock)block;
- (void)changeSubCategory:(NSArray *)subCategories
                withBlock:(WMChaneEventsCompletionBlock)block;



// Data Source


@end
