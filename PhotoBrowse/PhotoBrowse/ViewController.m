//
//  ViewController.m
//  PhotoBrowse
//
//  Created by Smile on 16/11/23.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "ViewController.h"
#import "PJPhotoBrowse.h"
#import "Masonry.h"

#define __WS(weakSelf)              __weak __typeof(&*self)weakSelf = self;
#define PJ_WEAKSELF(weakSelf)       __WS(weakSelf)

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UIView *tableViewArea;

@property (nonatomic, strong) PJPhotoBrowse *photoBrowse;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    PJ_WEAKSELF(ws);
    _dataArray = [NSMutableArray array];
    for (int i = 1; i <= 8; i++) {
        NSString *photoName = [NSString stringWithFormat:@"icon%d.jpg", i];
        [_dataArray addObject:photoName];
    }
    
    _photoBrowse = [[PJPhotoBrowse alloc] initWithDataArray:_dataArray];
    [_photoBrowse setSelectedBlock:^(NSIndexPath *indexPath){
        ws.showImageView.image = [UIImage imageNamed:ws.dataArray[indexPath.row]];
    }];
    
    [self.tableViewArea addSubview:_photoBrowse];
    [_photoBrowse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableViewArea);
    }];
}

- (IBAction)buttonDidClicked:(id)sender {
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [_photoBrowse scrollItemToIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
}

@end
