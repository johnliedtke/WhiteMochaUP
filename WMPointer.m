//
//  WMPointer.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 7/24/14.
//
//

#import "WMPointer.h"
#import <Parse/PFObject+Subclass.h>

@interface WMPointer ()

@property (strong, readwrite) NSString *parent;

@end


@implementation WMPointer
@dynamic parent;

+ (NSString *)parseClassName
{
    return @"WMPointer";
}

- (instancetype)initWithParent:(NSString *)parent
{
    self = [WMPointer object];
    if (self) {
        self.parent = parent;
    }
    return self;
}

@end
