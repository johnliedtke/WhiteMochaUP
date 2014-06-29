//
//  WMPoll.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 5/31/14.
//
//

#import <Parse/Parse.h>
#import "WMPollAnswer.h"

@interface WMPoll : PFObject<PFSubclassing,UIAlertViewDelegate>
typedef void (^WMCurrentPollCompletionBlock)(BOOL success, WMPoll *poll, NSError *error);

@property (nonatomic, readonly) NSUInteger votes;
@property (nonatomic,readonly) NSString *question;
@property (nonatomic, readonly) NSArray *answers; // of WMAnswer
@property (nonatomic, readonly) BOOL currentPoll;

// designated initialzer
- (instancetype)initWithQuestion:(NSString *)question
                        answers:(NSArray *)answers;


+ (void)fetchCurrentPoll:(WMCurrentPollCompletionBlock)callback;
+ (NSString *)pollDate;
+ (PFQuery *)currentPollQuery;
+ (UIColor *)pollColor:(NSUInteger)colorNum;

- (BOOL)isVotedUser:(PFUser *) user;
- (void)userVotedAnswer:(WMPollAnswer *)answer
                   user:(PFUser *)user;
@end
