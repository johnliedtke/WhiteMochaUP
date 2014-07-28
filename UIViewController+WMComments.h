//
//  UIViewController+WMComments.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/18/14.
//
//

#import <UIKit/UIKit.h>
#import "WMComment.h"

@interface UIViewController (WMComments)

- (void)setUpCommentCells:(UITableView *)tableView;

- (void)addComment:(NSString *)comment parent:(PFObject *)parent withSelectors:(NSArray *)selectors;
- (void)deleteComment:(WMComment *)comment withSelectors:(NSArray *)selectors;

- (NSUInteger)numberOfCommentSections;

- (id)setUpCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (NSUInteger)numberOfRowsInCommentSection:(UITableView *)tableView inSection:(NSUInteger)section;


- (void)setCommentParent:(PFObject *)parent;
- (void)setEnableComments:(NSNumber *)enabled;
- (void)fetchComments:(UITableView *)tableView;
- (float)heightForCommentRow:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)didSelectCommentRow:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (float)heightForCommentFooter:(UITableView *)tableView inSection:(NSUInteger)section;

@end
