//
//  WMCommentsViewController.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 6/22/14.
//
//

#import <Parse/Parse.h>
#import "WMCommentBar.h"

@interface WMCommentsViewController : PFQueryTableViewController <WMCommentBarDelegate>

@property (nonatomic, strong) PFObject *parent;
@property (nonatomic, readonly) WMCommentBar *commentBar;
@property (nonatomic) BOOL showKeyboardOnLoad;


// Designated init
- (id)initWithParent:(PFObject *)parent;

@end
