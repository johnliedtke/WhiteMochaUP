//
//  WMPlace.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/20/13.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface WMPlace : PFObject<PFSubclassing>
{

}


// Name of the place
@property (nonatomic, copy) NSString *name;


// The name of the class for Parse
+ (NSString *)parseClassName;


@end
