//
//  PJPhotoBrowseDataSource.m
//  PhotoBrowse
//
//  Created by Smile on 16/11/23.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "PJPhotoBrowseDataSource.h"
#import "PJPhotoBrowseCell.h"

@interface PJPhotoBrowseDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end

@implementation PJPhotoBrowseDataSource

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock {
    
    if (self = [super init]) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PJPhotoBrowseCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    if (!cell) {
        cell = [[PJPhotoBrowseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    
    if (self.configureCellBlock) {
        id item = [self itemAtIndexPath:indexPath];
        self.configureCellBlock(cell, item, indexPath);
    }
    
    return cell;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.items[(NSUInteger) indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _items.count;
}

@end
