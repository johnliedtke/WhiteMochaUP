//
//  WMEventsMainViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/29/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WMAddEventDelegate.h"
#import "WMConstants.h"
#import "WMEventDetailViewController.h"
@class WMRSSChannel, WMWebViewController;



@interface WMEventsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSXMLParserDelegate, WMAddEventDelegate, WMEventDetailDelegate>
{

    __unsafe_unretained IBOutlet UISegmentedControl *eventsSwitcher;
    __unsafe_unretained IBOutlet UITableView *eventsTable;
    
    NSURLConnection *connection;
    NSMutableData *xmlData;
    NSMutableArray *sports;
    NSMutableArray *dates;
    NSMutableArray *allEvents;
    WMRSSChannel *channel;
    NSMutableDictionary *eventDictionary;
    UIRefreshControl *refreshControl;
    
    // Clubs
    NSMutableArray *parseEvents;
    NSDictionary *clubRef;
}


@property (nonatomic, strong) WMWebViewController *webViewController;
@property (nonatomic, strong) NSString *eventSelected;


// Constants




- (void)fetchEntries;
- (void)changeEvents:(NSString *)event;

@end
