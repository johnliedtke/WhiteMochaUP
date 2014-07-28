//
//  WMPoll.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 5/31/14.
//
//

#import "WMPoll.h"
#import <Parse/PFObject+Subclass.h>
#import "WMComment.h"

@interface WMPoll ()

@property (nonatomic, readwrite) NSUInteger votes;
@property (nonatomic,readwrite) NSString *question;
@property (nonatomic, retain) NSMutableArray *voters; // of PFUser
@property (nonatomic, readwrite) NSMutableArray *answers; // of WMAnswer
@property (nonatomic, readwrite) BOOL currentPoll;
@property (nonatomic, readwrite) NSDate *pollDate;
@property (nonatomic, readwrite) NSUInteger pollNumber;
@property (nonatomic, readwrite) WMPointer *commentPointer;

@end

@implementation WMPoll
@dynamic votes, question, voters, answers, currentPoll, pollDate, pollNumber, commentPointer;

+ (NSString *)parseClassName
{
    return @"WMPoll2";
}


+ (void)fetchCurrentPoll:(WMCurrentPollCompletionBlock)callback
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMPoll2"];
    [query whereKey:@"currentPoll" equalTo:[NSNumber numberWithBool:YES]];
    [query includeKey:@"answers"];
   [query includeKey:@"comments"];
    [query includeKey:@"newComments"];
    //query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            callback(YES, [objects firstObject], error);
        } else {
            callback(NO, nil, error);
            NSLog(@"no shit");
        }
    }];
}

+ (PFQuery *)currentPollQuery
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMPoll2"];
    [query whereKey:@"currentPoll" equalTo:[NSNumber numberWithBool:YES]];
    [query includeKey:@"answers"];
    return query;
}

+ (NSString *)pollDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (instancetype)initWithQuestion:(NSString *)question answers:(NSArray *)answers
{
    self = [WMPoll object];
    
    if (self) {
        self.question = question;
        self.answers = [[NSArray alloc] initWithArray:answers];
        self.votes = 0;
        self.commentPointer = [[WMPointer alloc] initWithParent:self];
    }
    return self;
}

- (BOOL)isVotedUser:(PFUser *)user
{
    for (PFUser *usr in self.voters) {
        if ([usr isKindOfClass:[PFUser class]]) {
            if ([[user objectId] isEqualToString:[usr objectId]]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)userVotedAnswer:(WMPollAnswer *)answer
                   user:(PFUser *)user
{
    // increment votes and add user
    [self incrementKey:@"votes"];
    [answer incrementVote];
    [self addObject:user forKey:@"voters"];
    [self saveInBackground];
}

+ (UIColor *)pollColor:(NSUInteger)colorNum;
{
    switch (colorNum) {
        case 0:
            return [UIColor colorWithRed:211.0/255.0 green:189.0/255.0 blue:228.0/255.0 alpha:1.0];//[UIColor colorWithRed:11/255.0f green:211/255.0f blue:24/255.0f alpha:1.0f];
            break;
        case 1:
            return [UIColor colorWithRed:172.0/255.0f green:137.0/255.0f blue:200.0/255.0f alpha:1.0f];
            break;
        case 2:
            return [UIColor colorWithRed:134.0/255.0f green:92.0/255.0f blue:168.0/255.0f alpha:1.0f];
            break;
        case 3:
            return [UIColor colorWithRed:106.0/255.0f green:60.0/255.0f blue:143.0/255.0f alpha:.95f];
            break;
        default:
            break;
    }
    return nil;
    
}



@end
