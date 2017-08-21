//
//  PJPhotoBrowseCell.m
//  PhotoBrowse
//
//  Created by Smile on 16/11/23.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "PJPhotoBrowseCell.h"
#import "Masonry.h"

const NSInteger scrollBarHeight = 4.0;

@interface PJPhotoBrowseCell ()

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIImageView *scrollBar;

@end

@implementation PJPhotoBrowseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        _photoView = [[UIImageView alloc] init];
        _scrollBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBar"]];
        [_scrollBar setBackgroundColor:[UIColor yellowColor]];

        [self addSubview:_photoView];
        [self addSubview:_scrollBar];
        
        [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [_scrollBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(scrollBarHeight);
        }];

    }
    return self;
}

- (void)showScrollBar:(BOOL)show {
    
    if (show) {
        _scrollBar.hidden = NO;
    } else {
        _scrollBar.hidden = YES;
    }
}

- (void)setPhotoName:(NSString *)photoName {
    
    _photoName = photoName;
    _photoView.image = [UIImage imageNamed:photoName];
}

@end
