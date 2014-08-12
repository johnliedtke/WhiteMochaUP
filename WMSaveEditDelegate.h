//
//  WMSaveEditDelegate.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/2/14.
//
//

#import <Foundation/Foundation.h>

@protocol WMSaveEditDelegate <NSObject>

- (void)edit;
- (void)save;

@property (nonatomic, weak) id <WMSaveEditDelegate> delegate;

@end
