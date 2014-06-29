//
//  WMEventsMainViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/29/13.
//
//

#import "WMEventsViewController.h"
#import "WMRSSChannel.h"
#import "WMRSSItem.h"
#import "WMWebViewController.h"
#import "WMEventCell.h"
#import "WMEvent.h"
#import "WMAddEventCategoriesViewController.h"
#import "WMEventDetailViewController.h"

@interface WMEventsViewController ()


@end

@implementation WMEventsViewController
@synthesize webViewController;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //[self fetchEntries];
        dates = [[NSMutableArray alloc] init];
        eventDictionary = [[NSMutableDictionary alloc] init];
        parseEvents = [[NSMutableArray alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"clubs" ofType:@"plist"];
        clubRef = [[NSDictionary alloc] initWithContentsOfFile:path];
        [self setTitle:@"Events"];
        [self fetchEntries];
        // Appearance
        PURPLEBACK
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  // [self changeEvents:@"All"];
    
    // Cell shit
    [eventsTable registerNib:[UINib nibWithNibName:@"WMEventCell" bundle:nil]
      forCellReuseIdentifier:@"WMEventCell"];

    
    // Segmented thingy
    [eventsSwitcher addTarget:self
                       action:@selector(action:)
             forControlEvents:UIControlEventValueChanged];
    
    // Pull to refresh

    //[self changeEvents:@"refresh"];

    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = eventsTable;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getConnections) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = refreshControl;

    
    // LOAD EVERYTHING
    [refreshControl beginRefreshing];
    [self getConnections];
    
    // Add event
   // UIBarButtonItem *addEventButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addEvent)];
    UIBarButtonItem *addEventButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
    //[addEventButton setTintColor:PURPLECOLOR];
    [[self navigationItem] setRightBarButtonItem:addEventButton];
    
    //
    [eventsSwitcher setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [eventsSwitcher setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    [eventsSwitcher setTintColor:[[UIColor alloc] initWithRed:98/255.0 green:87.0/255.0 blue:159.0/255.0 alpha:1.0]];
    
}

- (void)addEvent
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"WMAddEventCategories" bundle:nil];
    WMAddEventCategoriesViewController *addEventCatViewController = [story instantiateViewControllerWithIdentifier:@"WMAddEventCategories"];
    [[self navigationController] pushViewController:addEventCatViewController animated:YES];

}

- (void)getConnections
{
    [parseEvents removeAllObjects];
    [self fetchEntries];
    PFQuery *query = [PFQuery queryWithClassName:@"WMEvent"];
    [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                int i = 0;
                NSDate *currentDate = [NSDate date];
                
                //Has the date passed?
                if ([currentDate compare:[object objectForKey:@"eventDate"]] == NSOrderedDescending) {[object deleteInBackground];continue;}
                [parseEvents addObject:object];
                i++;
            }
            if ([eventsSwitcher selectedSegmentIndex] == 0) {
                [self changeEvents:@"all"];
            } else {
                [self changeEvents:[self eventSelected]];
            }
            [refreshControl endRefreshing];

        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error :-( Try checking network connection." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [av show];
        }
    }];
}

-(void)eventAdded
{
    NSLog(@"It worked");
    [self getConnections];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Event was added! Refreshing..." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [av show];
}

- (void)changeEvents:(NSString *)category
{
    [self setEventSelected:category];
    [dates removeAllObjects];
   //[clubs removeAllObjects];
    [eventDictionary removeAllObjects];
    
    // Make RSSItems WMEvents
    NSMutableArray *tempItems = [[NSMutableArray alloc] init];
    for (WMRSSItem *item in [channel items]) {

        
        // Remove the time fromt the title
        NSString *title = [item title];
        NSError *error;
        
        // Our sexy little pattern
        NSString *titlePattern = @"^(.*?)\\d\\:\\d{2}";
        NSRange stringRange = NSMakeRange(0, title.length);
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:titlePattern options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSTextCheckingResult *match = [regex firstMatchInString:title options:0 range:stringRange];
        
        NSString *itemTitle;
        if ([[item category] isEqualToString:SPORTS])
            itemTitle = [title substringWithRange:[match rangeAtIndex:1]];    // [match rangeAtIndex:1] gives the range of the group in parentheses
        else
            itemTitle = [item title];
        
        
        // Location
        NSRange range = [[item about] rangeOfString:@"-"];
        NSString *location = [[[item about] substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        // Image
        UIImage *image;
        if ([itemTitle rangeOfString:@"soccer" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"classic.png"];
        } else if ([itemTitle rangeOfString:@"volleyball" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"volleyball.png"];
        } else if ([[item category] isEqualToString:ACADEMICS]) {
            image = [UIImage imageNamed:@"school-50.png"];
        } else if ([itemTitle rangeOfString:@"basketball" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"basketall.png"];
        } else if ([itemTitle rangeOfString:@"intramural" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"trophy-50.png"];
        } else if ([itemTitle rangeOfString:@"robot" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"robot-50.png"];
        } else if ([itemTitle rangeOfString:@"movie" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"movie-50.png"];
        } else if ([itemTitle rangeOfString:@"mass" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"cross-50.png"];
        } else if ([itemTitle rangeOfString:@"ecology" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"leaf-50.png"];
        } else if ([itemTitle rangeOfString:@"ACM" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"cat-50.png"];
        } else if ([itemTitle rangeOfString:@"IEEE" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"computer-50.png"];
        } else if ([itemTitle rangeOfString:@"dance" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"cat-50.png"];
        } else if ([itemTitle rangeOfString:@"tau" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"pi-50.png"];
        } else if ([itemTitle rangeOfString:@"music" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"music-50.png"];
        } else if ([itemTitle rangeOfString:@"fish" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"clown_fish-50.png"];
        } else if ([itemTitle rangeOfString:@"sport" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"sports_mode-50.png"];
        } else if ([itemTitle rangeOfString:@"international" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            image = [UIImage imageNamed:@"great_wall-50.png"];
        } else {
            image = [UIImage imageNamed:@"calendar-50.png"];
        }
        
        
        WMEvent *event = [[WMEvent alloc] initWithTitle:itemTitle location:location eventType:[item category] eventDate:[item eventDate] image:image];
        [event setDetails:[item link]];
        [event setIsRSS:YES];
        [tempItems addObject:event];
    }


    
    // Make clubs into WMEvents
    for (PFObject *parseEvent in parseEvents) {
        WMEvent *event;
        if ([parseEvent objectForKey:@"club"]) {
            NSLog(@"Adding CLUB");
        
            // Fetch image
            NSString *imgString;
            NSArray *cat = [clubRef objectForKey:[parseEvent objectForKey:@"clubCategory"]];
            for (NSDictionary *dict in cat) {
                if ([[dict objectForKey:@"name"] isEqualToString:[parseEvent objectForKey:@"club"]]) {
                    imgString = [dict objectForKey:@"image"];
                }
            }
            NSMutableString *clubTitle = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", [parseEvent objectForKey:@"club"], @"Meeting"]];
            
            event = [[WMEvent alloc] initWithClub:[parseEvent objectForKey:@"club"] location:[parseEvent objectForKey:@"location"] eventType:[parseEvent objectForKey:@"eventType"] eventDate:[parseEvent objectForKey:@"eventDate"] details:[parseEvent objectForKey:@"details"] clubCategory:[parseEvent objectForKey:@"clubCategory"] user:[parseEvent objectForKey:@"user"] image:[UIImage imageNamed:imgString]];
            [event setTitle:clubTitle];
            [event setSponsor:[parseEvent objectForKey:@"sponsor"]];
            NSLog(@"event: %@", event);
        } else {
            NSLog(@"Adding other event");
            event = [[WMEvent alloc] initWithTitle:[parseEvent objectForKey:@"title"] location:[parseEvent objectForKey:@"location"] eventType:[parseEvent objectForKey:@"eventType"] eventDate:[parseEvent objectForKey:@"eventDate"] image:[UIImage imageNamed:@"event.png"]];
            [event setUser:[parseEvent objectForKey:@"user"]];
            [event setSponsor:[parseEvent objectForKey:@"sponsor"]];
            [event setDetails:[parseEvent objectForKey:@"details"]];
        }
        [event setParseObject:parseEvent];
        [tempItems addObject:event];
    }
    
    NSArray *sortedArray;
    sortedArray = [tempItems sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(WMEvent*)a eventDate];
        NSDate *second = [(WMEvent*)b eventDate];
        return [first compare:second];
    }];
    
    allEvents = [[NSMutableArray alloc] initWithArray:sortedArray];
    //tempItems = nil;
    
    
    
    // Sort dates...
    for (WMEvent *evt in allEvents) {
        if (![category isEqualToString:[evt eventType]] && [eventsSwitcher selectedSegmentIndex] != 0) {
            if (![self doesClubPertain:evt]) {
                continue;
            }
        }
        
        // Make them strings...
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, MMM d"];
        NSString *compareDate = [dateFormatter stringFromDate:[evt eventDate]];
        BOOL copy = NO;
        for (NSString *dt in dates) {
            if ([dt isEqualToString:compareDate]) {
                copy = YES;
            }
        }
        if (!copy) {
            [dates addObject:compareDate];
            [eventDictionary setObject:[[NSMutableArray alloc] initWithObjects:evt, nil] forKey:compareDate];
        } else {
            [[eventDictionary objectForKey:compareDate] addObject:evt];
        }
    }
    
    
    [eventsTable reloadData];
}


- (void)action:(id)sender
{
    switch ([eventsSwitcher selectedSegmentIndex]) {
        case 0:
            [self changeEvents:@"all"];
            break;
        case 1:
            [self changeEvents:ACADEMICS];
            break;
        case 2:
            [self changeEvents:SPORTS];
            break;
        case 3:
            [self changeEvents:CLUBS];
            break;
        case 4:
            [self changeEvents:FUN];
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    eventsSwitcher = nil;
    eventsTable = nil;
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (void)fetchEntries
{
    // Create a new data container for the stuff that comes back from the service
    xmlData = [[NSMutableData alloc] init];
    
    // Construct a URL that will ask the service for what you want -
    // not we can concatenate literal strings together on multiple
    // lines in this way - this results in a single NSString instance
    NSURL *url = [NSURL URLWithString:@"https://calendar.up.edu/MasterCalendar/RSSFeeds.aspx?data=rWVImWG4wi1iC5u2UcXAOcpvbDVSuYma"];
    
    // Put that URL into an NSURL request
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Create a connection that will exchange this request for data from the URL
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    // Add the incoming chunk of data to the container we are keeping
    // The data always comes in the correct order
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    // Create the parser object with the data received from UP
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    // Give it a delegate = ignore the warning for now
    [parser setDelegate:self];
    
    // Tell it to start parsing - the document will be parsed and
    // the deleagte of NSXMLParser will get all of its delegate messages
    // sent to it beofore its line finsihes execution - it is blocking
    [parser parse];
    
    // Get rid of the XML data we no longer need it
    xmlData = nil;
    
    // Get rid of the connection, no longer need it
    connection = nil;
    
    // Reload the table.. for now, the table will be empty.
    //[eventsTable reloadData];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    // Release the connection object, we're done with it
    connection = nil;
    
    // Release the xmlData oject
    xmlData = nil;
    
    // Grab the description of the error object passed to us
    NSString *errorString = [NSString stringWithFormat:@"Fetch Failed: %@", [error localizedDescription]];
    
    // Create and show an alert view with this error displayed
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqual:@"channel"]) {
        
        // If the parser saw a channel, create new instance, store in our ivar
        channel = [[WMRSSChannel alloc] init];
        
        // Give the channel object aponter back to ourselves for later
        [channel setParentParserDelegate:self];
        
        // Set the parser's delegate to the channel object
        [parser setDelegate:channel];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return [dates count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return dates[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[eventDictionary objectForKey:dates[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // Our custom cell!! :D
    WMEventCell *cell = (WMEventCell *)[tableView dequeueReusableCellWithIdentifier:@"WMEventCell"];
    
    WMEvent *event = [[eventDictionary objectForKey:dates[[indexPath section]]] objectAtIndex:[indexPath row]];
   
    // Title
    [[cell titleLabel] setText:[event title]];
    
    // Date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm"];
    [[cell timeLabel] setText:[dateFormatter stringFromDate:[event eventDate]]];
    [dateFormatter setDateFormat:@"a"];
    [[cell periodLabel] setText:[dateFormatter stringFromDate:[event eventDate]]];
    
    // Image
    [[cell icon] setImage:[event image]];
    
    // Location
    [[cell locationLabel] setText:[event location]];
    
    
    
    
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Grab the selected item
    WMEvent *entry = [[eventDictionary objectForKey:dates[[indexPath section]]] objectAtIndex:[indexPath row]];
    
    if ([entry isRSS]) {
    
    // Constructa URL wit the link string of the item
    NSURL *url = [NSURL URLWithString:[entry details]];
    
    // Contruct a request object with that URL
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Load the request inot the web view
        [webViewController setSizeScreen:5.0];
    [[webViewController webView] loadRequest:req];
    
    // Set zoom
    [[webViewController webView] stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 5.0;"];
    
    // Set the title of the web view controller's navigation item
    [[webViewController navigationItem] setTitle:@"Events"];
    
    // Push the web view controller onto the navigation stack - this implicitly
    // creates the web view controller's view the first through
    
    [[self navigationController] pushViewController:webViewController animated:YES];
    } else {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"WMEventDetailView" bundle:nil];
        WMEventDetailViewController *eventDetailView = [story instantiateViewControllerWithIdentifier:@"WMEventDetailView"];
        [eventDetailView setEvent:entry];
        [eventDetailView setEventDetailDelegate:self];
        [[self navigationController] pushViewController:eventDetailView animated:YES];
    }
}

-(void)deleteListing:(PFObject *)event
{
    [event deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self getConnections];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Event was deleted! Refreshing..." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [av show];
        } else if (error) {
            NSLog(@"Error");
        }
    }];
}



- (BOOL)doesClubPertain:(WMEvent *)evt {
    if ([[self eventSelected] isEqualToString:ACADEMICS]) {
        return [[evt clubCategory] isEqualToString:@"academic"];
    } else if ([[self eventSelected] isEqualToString:SPORTS]) {
        return [[evt clubCategory] isEqualToString:@"clubSports"] || [[evt eventType] isEqualToString:INTAMURAL];
    } else if ([[evt eventType] isEqualToString:@"Student Club"] && ![[self eventSelected] isEqualToString:FUN]) {
        return YES;
    } else {
        return NO;
    }
}


@end
