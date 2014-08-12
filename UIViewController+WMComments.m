//
//  UIViewController+WMComments.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/18/14.
//
//

#import "UIViewController+WMComments.h"
#import "MBProgressHUD.h"
#import "WMCommentsHeaderTableViewCell.h"
#import "WMCommentTableViewCell.h"
#import "WMAddCommentTableViewCell.h"
#import "WMCommentsViewController.h"
#import <objc/runtime.h>



@implementation UIViewController (WMComments)
static char recentCommentsKey;
static char commentParentKey;
static char enableComments;
static char commentCountKey;


- (void)setEnableComments:(NSNumber *)enabled
{
    objc_setAssociatedObject(self, &enableComments,
                             enabled, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)enableComments
{
    return objc_getAssociatedObject(self, &enableComments);
}


- (void)setRecentComments:(NSMutableArray *)recentComments
{
    objc_setAssociatedObject(self, &recentCommentsKey,
                             recentComments, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)recentComments
{
    return objc_getAssociatedObject(self, &recentCommentsKey);
}

- (void)setCommentParent:(WMPointer *)parent
{
    objc_setAssociatedObject(self, &commentParentKey,parent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)commentCount
{
    return objc_getAssociatedObject(self, &commentCountKey);
}

- (void)setCommentCount:(NSNumber *)commentCount
{
    objc_setAssociatedObject(self, &commentCountKey,commentCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (WMPointer *)parent
{
    return objc_getAssociatedObject(self, &commentParentKey);
}

- (void)addComment:(NSString *)comment parent:(PFObject *)parent withSelectors:(NSArray *)selectors;
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Adding comment...";
    hud.graceTime = 2.0;
    [WMComment addComment:comment parent:parent withBlock:^(BOOL success, NSError *error) {
        if (success) {
            hud.labelText = @"Sucess! Commend added.";
            [hud hide:YES afterDelay:0.5];
            [self performSelectorsFromArray:selectors];
        } else {
            hud.labelText = @"ERROR";
            [hud hide:YES afterDelay:0.5];
        }
    }];
    
}

- (void)performSelectorsFromArray:(NSArray *)stringSelectors
{
    for (NSString *stringSelector in stringSelectors) {
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@", stringSelector]);
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector withObject:0];
        }
    }
}

- (void)fetchComments:(UITableView *)tableView
{
    if (![self parent] || ![[self enableComments] boolValue])  return;
    
//    PFQuery *query = [PFQuery queryWithClassName:@"WMComment"];
//    [query includeKey:@"user"];
//    [query whereKey:@"parent" equalTo:[self parent]];
//    query.limit = 3;
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            if (![self recentComments]) {
//                [self setRecentComments:[NSMutableArray array]];
//            }
//            [[self recentComments] removeAllObjects];
//            [[self recentComments] addObjectsFromArray:objects];
//            [tableView reloadData];
//        } else {
//            NSLog(@"Error with comments");
//        }
//    }];
    if (![self recentComments]) {
        [self setRecentComments:[NSMutableArray array]];
    }

    
    [PFCloud callFunctionInBackground:@"fetchRecentComments" withParameters:@{@"commentPointer" : [self parent].objectId}block:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            [[self recentComments] removeAllObjects];
            [[self recentComments] addObjectsFromArray:[dictionary objectForKey:@"comments"]];
            [self setCommentCount:[NSNumber numberWithInt:[[dictionary objectForKey:@"count"] intValue]]];
            [tableView reloadData];

    
        } else {
            NSLog(@"%@", error);
        }
    }];

}

- (void)deleteComment:(WMComment *)comment withSelectors:(NSArray *)selectors
{
    if (!comment || selectors.count == 0 || ![[self enableComments] boolValue]) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Deleting comment...";
    hud.graceTime = 2.0;
    [comment deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            hud.labelText = @"Sucess! Commend deleted.";
            [hud hide:YES afterDelay:0.5];
            [self performSelectorsFromArray:selectors];
        } else {
            hud.labelText = @"ERROR DELETING COMMENT";
            [hud hide:YES afterDelay:2.0];
        }
    }];

}

- (void)setUpCommentCells:(UITableView *)tableView
{
    if (![[self enableComments] boolValue]) {
        return;
    }
    // Comment Cells
    [tableView registerNib:[UINib nibWithNibName:@"WMCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMCommentTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"WMCommentsHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMCommentsHeaderTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"WMAddCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"WMAddCommentTableViewCell"];
}

- (NSUInteger)numberOfCommentSections
{
    if (![[self enableComments] boolValue]) {
        return 0;
    }
    return 3;
}

- (NSUInteger)numberOfRowsInCommentSection:(UITableView *)tableView inSection:(NSUInteger)section
{
    if (![[self enableComments] boolValue]) {
        return 0;
    }
    
    if ([self isHeaderSection:tableView inSection:section]) {
        return 1;
    } else if ([self isCommentsSection:tableView inSection:section]) {
        return [self recentComments].count;
    } else if ([self isAddCommentsSection:tableView inSection:section]) {
        return 1;
    }
    { return 0; }
    

}

- (float)heightForCommentRow:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    if (![[self enableComments] boolValue]) {
        return 0;
    }
    
    int height = 0;
    if ([self isHeaderSection:tableView inSection:indexPath.section]) {
        height = 45.0;
    } else if ([self isCommentsSection:tableView inSection:indexPath.section]) { // Comments
        height = [[[self recentComments] objectAtIndex:indexPath.row] commentHeight];
    } else if ([self isAddCommentsSection:tableView inSection:indexPath.section]) {
        height = 50;
    }
    return height;
}

- (float)heightForCommentFooter:(UITableView *)tableView inSection:(NSUInteger)section;
{
    if (![[self enableComments] boolValue]) {
        return 0;
    }
    
    if ([self isAddCommentsSection:tableView inSection:section]) {
        return 25.0;
    }
    return 0;
}

- (void)didSelectCommentRow:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    if (![[self enableComments] boolValue]) {
        return;
    }
    
    if ([self isHeaderSection:tableView inSection:indexPath.section]) {
        [self showComments:NO];
    } else if ([self isAddCommentsSection:tableView inSection:indexPath.section]) {
        [self showComments:YES];
    }
}

- (id)setUpCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    if (![[self enableComments] boolValue]) {
        return nil;
    }
    
    id cell;
    if ([self isHeaderSection:tableView inSection:indexPath.section]){
        cell = (WMCommentsHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMCommentsHeaderTableViewCell" forIndexPath:indexPath];
        [[cell titleLabel] setText:[NSString stringWithFormat:@"Comments (%d)", [[self commentCount] intValue]]];
        [cell setDelegate:self];
    } else if ([self isCommentsSection:tableView inSection:indexPath.section]) {
        cell = (WMCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMCommentTableViewCell" forIndexPath:indexPath];
        [cell setComment:[self recentComments][indexPath.row]];
        
    } else if ([self isAddCommentsSection:tableView inSection:indexPath.section]) {
        cell = (WMAddCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMAddCommentTableViewCell" forIndexPath:indexPath];
    }

    return cell;
}

- (void)showComments:(BOOL)showKeyboard
{
    if (![[self enableComments] boolValue]) {
        return;
    }
    
    if ([self parent]) {
        WMCommentsViewController *commentsVC = [[WMCommentsViewController alloc] initWithParent:[self parent]];
        
        [commentsVC setParent:[self parent]];
        if (showKeyboard) {
            [commentsVC.commentBar.textView becomeFirstResponder];
            [commentsVC setShowKeyboardOnLoad:YES];
        }
        [self.navigationController pushViewController:commentsVC animated:YES];
    }
}


- (void)viewAllPressed
{
    [self showComments:NO];
}


- (BOOL)isHeaderSection:(UITableView *)tableView inSection:(NSUInteger)section
{
    return section == [tableView numberOfSections] -3;
    
}

- (BOOL)isCommentsSection:(UITableView *)tableView inSection:(NSUInteger)section
{
    return section == [tableView numberOfSections] -2;
}

- (BOOL)isAddCommentsSection:(UITableView *)tableView inSection:(NSUInteger)section
{
    return section == [tableView numberOfSections] -1;
}



@end
