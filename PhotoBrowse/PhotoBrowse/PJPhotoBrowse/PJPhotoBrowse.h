//
//  PJPhotoBrowse.h
//  PhotoBrowse
//
//  Created by Smile on 16/11/23.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PJPJPhotoBrowseBlock)(NSIndexPath *indexPath);

@interface PJPhotoBrowse : UIView

@property (nonatomic, copy) PJPJPhotoBrowseBlock selectedBlock;

- (instancetype)initWithDataArray:(NSArray *)dataArray;
- (void)scrollItemToIndexPath:(NSIndexPath *)indexPath;

@end
