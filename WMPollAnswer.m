//
//  WMPollAnswer.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 5/31/14.
//
//

#import "WMPollAnswer.h"
#import <Parse/PFObject+Subclass.h>


@interface WMPollAnswer ()

@property (nonatomic, readwrite) NSUInteger votes;
@property (nonatomic, readwrite) NSString *answer;


@end


@implementation WMPollAnswer
@dynamic  answer, votes;

+ (NSString *)parseClassName
{
    return  @"WMPollAnswer";
}

+ (NSArray *)createAnswersWithStringArray:(NSArray *)answers
{
    NSMutableArray *newAnswers = [[NSMutableArray alloc] init];
    for (NSString *awr in answers) {
        if ([awr isKindOfClass:[NSString class]]) {
            WMPollAnswer *newAnswer = [[WMPollAnswer alloc] initWithAnswer:awr];
            [newAnswers addObject:newAnswer];
        }
    }
    return [[NSArray alloc] initWithArray:newAnswers];
}

- (instancetype)initWithAnswer:(NSString *)answer
{
    self = [WMPollAnswer object];
    
    if (self) {
        self.answer = answer;
        self.votes = 0;
        //[self saveInBackground];
    }
    return self;
}

- (void)incrementVote
{
    [self incrementKey:@"votes"];
    [self saveInBackground];
}

- (NSUInteger)calculatePercentage:(NSUInteger)totalVotes
{
    return (NSUInteger)((float)self.votes/totalVotes * 100);
}


@end
