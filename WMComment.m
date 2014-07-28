//
//  WMComment.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/8/14.
//
//

#import "WMComment.h"
#import <Parse/PFObject+Subclass.h>


@interface WMComment ()

@property (nonatomic, readwrite) NSString *comment;
@property (nonatomic, readwrite) NSString *author;
@property (nonatomic, readwrite) PFUser *user;
@property (nonatomic, readwrite) NSDate *commentDate;
@property (nonatomic, readwrite) NSUInteger *likes;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, readwrite) WMPointer *parent;


@end


@implementation WMComment
@dynamic comment,textView,commentDate,likes,author, user, parent;

+ (NSString *)parseClassName
{
    return @"WMComment";
}

- (instancetype)initWithComment:(NSString *)comment parent:(PFObject *)parent
{
    self = [WMComment object];
    
    if (self) {
        self.comment = comment;
        //self.parent = parent;
    }
    return self;
    
}

+ (void)addComment:(NSString *)comment parent:(PFObject *)parent
{
    WMComment *newComment = [[WMComment alloc] initWithComment:comment parent:parent];
    [newComment setUser:[PFUser currentUser]];
    [newComment saveInBackground];
}

+ (void)addComment:(NSString *)comment parent:(PFObject *)parent withBlock:(WMCommentAddedCompletionBlock)callback
{
    WMComment *newComment = [[WMComment alloc] initWithComment:comment parent:parent];
    [newComment setUser:[PFUser currentUser]];
    [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            callback(succeeded, error);
    }];
}

+ (PFQuery *)fetchFiveComments:(PFObject *)parent
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMComment"];
    [query orderByDescending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    [query whereKey:@"parent" equalTo:parent];
    [query includeKey:@"user"];
    query.limit = 3;
    return query;
}

+ (PFQuery *)countComments:(PFObject *)parent
{
    PFQuery *query = [PFQuery queryWithClassName:@"WMComment"];
    [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    [query whereKey:@"parent" equalTo:parent];
    return query;
}


- (NSUInteger)commentHeight
{
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 217.0, 20.0) textContainer:nil];
    [tv setFont:[UIFont systemFontOfSize:14.0]];
    tv.textContainer.lineFragmentPadding = 0;
    tv.textContainerInset = UIEdgeInsetsZero;
    tv.text = self.comment;
    CGSize sizeThatShouldFitTheContent = [tv sizeThatFits:tv.frame.size];
    return sizeThatShouldFitTheContent.height + 50.0;
}

+ (NSString *)postDateString:(NSDate *)postDate
{
    NSString *dateString;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Time Constants
    double hoursInday = 24.0;
    double daysInWeek = 7.0;
    double secondsInMinute = 60.0;
    double secondsInHour = 3600;
    double secondsInDay = secondsInHour * hoursInday;
    
    // Calcuate hours
    NSTimeInterval secondsSincePost = [currentDate timeIntervalSinceDate:postDate];
    NSUInteger minutesSincePost = secondsSincePost / secondsInMinute;
    NSUInteger hoursSincePost = secondsSincePost / secondsInHour;
    NSUInteger daysSincePost = secondsSincePost / secondsInDay;
    
    
    // Create date string
    if (hoursSincePost == 0) { // less than 1 hour
        if (minutesSincePost == 0) { // less than 1 minute
            if (secondsSincePost  < 1) {
                dateString = @"Just now";
            } else {
                dateString = [NSString stringWithFormat:@"%d seconds ago",(int)secondsSincePost];
            }
        } else { // more than 1 minute
            dateString = minutesSincePost == 1 ? [NSString stringWithFormat:@"%lu minute ago", (unsigned long)minutesSincePost] : [NSString stringWithFormat:@"%lu minutes ago",(unsigned long)minutesSincePost];
        }
    } else if (hoursSincePost < hoursInday) { // less than 24 hours
        dateString = hoursSincePost == 1 ? [NSString stringWithFormat:@"%lu hour ago",(unsigned long)hoursSincePost] : [NSString stringWithFormat:@"%lu hours ago", (unsigned long)hoursSincePost];
    } else if (daysSincePost < daysInWeek) {
        [dateFormatter setDateFormat:@"EEEE 'at' h:mm a"];
        dateString = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:postDate]];
    } else {
        [dateFormatter setDateFormat:@"MMMM d 'at' h:mm a"];
        dateString = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:postDate]];
    }
    
    return dateString;
}

+ (UILabel *)noCommentsLabel:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"No Comments";
    label.textColor = [UIColor darkGrayColor];
    return label;
}

@end
