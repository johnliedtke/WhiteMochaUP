//
//  WMConstants.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/19/13.
//
//

#import <Foundation/Foundation.h>

@interface WMConstants : NSObject

#define PURPLECOLOR [UIColor colorWithRed:(111.0/255.0) green:(103.0/255.0) blue:(152.0/255.0) alpha:1]
#define PURPLEBACK UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];[newBackButton setTintColor:PURPLECOLOR];[[self navigationItem] setBackBarButtonItem:newBackButton];

extern NSString * const SPORTS;
extern NSString * const ACADEMICS;
extern NSString * const CLUBS;
extern NSString * const FUN;
extern NSString * const INTAMURAL;

@end
