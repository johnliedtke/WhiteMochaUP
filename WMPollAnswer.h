//
//  WMPollAnswer.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 5/31/14.
//
//

#import <Parse/Parse.h>

@interface WMPollAnswer : PFObject<PFSubclassing>

@property (nonatomic, readonly) NSString *answer;
@property (nonatomic, readonly) NSUInteger votes;

// designated initializer
- (instancetype)initWithAnswer:(NSString *)answer;

+ (NSArray *)createAnswersWithStringArray:(NSArray *)answers; // of NSString

- (void)incrementVote; // increment vote by 1
- (NSUInteger)calculatePercentage:(NSUInteger)totalVotes;


@end
