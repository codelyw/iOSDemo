//
//  PJPhotoBrowseCell.h
//  PhotoBrowse
//
//  Created by Smile on 16/11/23.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJPhotoBrowseCell : UITableViewCell

@property (nonatomic, copy) NSString *photoName;

- (void)showScrollBar:(BOOL)show;

@end
