//
//  PJPhotoBrowseDataSource.h
//  PhotoBrowse
//
//  Created by Smile on 16/11/23.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item, NSIndexPath *indexPath);

@interface PJPhotoBrowseDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
