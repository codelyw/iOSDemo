//
//  PJPhotoBrowse.m
//  PhotoBrowse
//
//  Created by Smile on 16/11/23.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "PJPhotoBrowse.h"
#import "PJPhotoBrowseDataSource.h"
#import "PJPhotoBrowseCell.h"
#import "Masonry.h"

static NSString *kcellIdentifier = @"PJPhotoBrowseCell";

@interface PJPhotoBrowse () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) PJPhotoBrowseDataSource *dataSource;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSIndexPath *initialIndexPath;

@end

@implementation PJPhotoBrowse

- (instancetype)initWithDataArray:(NSArray *)dataArray {
    
    if (self = [super init]) {
        _dataArray = dataArray;
        [self p_initContentTableView];
        _initialIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

- (void)scrollItemToIndexPath:(NSIndexPath *)indexPath {
    
    _initialIndexPath = indexPath;
    [_contentTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [_contentTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    [_contentTableView.delegate tableView:_contentTableView didSelectRowAtIndexPath:indexPath];
}

- (void)p_initContentTableView {
    
    _contentTableView = [[UITableView alloc] init];
    _contentTableView.showsVerticalScrollIndicator = NO;
    _contentTableView.showsHorizontalScrollIndicator = NO;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.delegate = self;
    _contentTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    [self p_creatDataSource];
    [self addSubview:_contentTableView];
    [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(self.mas_width);
        make.width.equalTo(self.mas_height);
    }];
}

- (void)p_creatDataSource {
    
    _dataSource = [[PJPhotoBrowseDataSource alloc] initWithItems:_dataArray cellIdentifier:kcellIdentifier configureCellBlock:^(PJPhotoBrowseCell *cell, NSString *item, NSIndexPath *indexPath) {
        cell.photoName = item;
        cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
        
        if (indexPath == _initialIndexPath || cell.selected) {
            _initialIndexPath = nil;
            [cell showScrollBar:YES];
        } else {
            [cell showScrollBar:NO];
        }
    }];
    
    _contentTableView.dataSource = _dataSource;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.bounds.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedBlock) {
        self.selectedBlock(indexPath);
    }
    [self p_show:YES scrollBarAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self p_show:NO scrollBarAtIndexPath:indexPath];
}

- (void)p_show:(BOOL)show scrollBarAtIndexPath:(NSIndexPath *)indexPath {
    
    PJPhotoBrowseCell *cell = [_contentTableView cellForRowAtIndexPath:indexPath];
    [cell showScrollBar:show];
}

@end
