//
//  WMArrayDataSource.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 8/9/14.
//
//

#import "WMArrayDataSource.h"

@interface WMArrayDataSource ()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation WMArrayDataSource

- (NSMutableArray *)items
{
    if (!_items) _items = [NSMutableArray array];
    return _items;
}

- (void)addItems:(NSArray *)items
{
    [self.items addObjectsFromArray:items];
}

- (void)removeAllItems
{
    [self.items removeAllObjects];
}

- (id)itemAtIndex:(NSUInteger)index
{
    if (index < self.items.count) {
        return self.items[index];
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate cellForItem:self.items[indexPath.row] forIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}



@end
