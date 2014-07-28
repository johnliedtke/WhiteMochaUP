//
//  WMComment.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/8/14.
//
//

#import <Parse/Parse.h>
#import "WMPointer.h"

@protocol WMCommentDelegate

@optional


@end
typedef void (^WMCommentAddedCompletionBlock)(BOOL success, NSError *error);
@interface WMComment : PFObject<PFSubclassing>

@property (nonatomic, readonly) NSString *comment;
@property (nonatomic, readonly) NSString *author;
@property (nonatomic, readonly) NSDate *commentDate;
@property (nonatomic, readonly) NSUInteger *likes;
@property (nonatomic, readonly) PFUser *user;
@property (nonatomic, readonly) WMPointer *parent;


// Designated initialzier 
- (instancetype)initWithComment:(NSString *)comment
                         parent:(PFObject *)parent;


+ (PFQuery *)fetchFiveComments:(PFObject *)parent;
+ (PFQuery *)countComments:(PFObject *)parent;
+ (void)addComment:(NSString *)comment parent:(PFObject *)parernt;
+ (void)addComment:(NSString*)comment
            parent:(PFObject *)parent
         withBlock:(WMCommentAddedCompletionBlock)callback;
+ (NSString *)postDateString:(NSDate *)postDate;
+ (UILabel *)noCommentsLabel:(CGRect)frame;



- (NSUInteger)commentHeight;

@end
