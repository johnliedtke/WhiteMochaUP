//
//  WMPointer.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/24/14.
//
//

#import <Parse/Parse.h>

@interface WMPointer : PFObject<PFSubclassing>


@property (nonatomic, readonly) NSString *parent;

- (instancetype)initWithParent:(PFObject *)parent;

@end
