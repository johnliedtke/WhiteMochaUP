//
//  WMArrayDataSource.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/9/14.
//
//

#import <Foundation/Foundation.h>

@protocol WMArrayDateSourceDelegate <NSObject>

-(UITableViewCell *)cellForItem:(id)item forIndexPath:(NSIndexPath *)indexPath;

@end

@interface WMArrayDataSource : NSObject <UITableViewDataSource>


- (void)addItems:(NSArray *)items;
- (void)removeAllItems;

- (id)itemAtIndex:(NSUInteger)index;


@property (nonatomic, weak) id <WMArrayDateSourceDelegate> delegate;

@end
