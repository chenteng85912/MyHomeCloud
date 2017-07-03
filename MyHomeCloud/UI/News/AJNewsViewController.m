//
//  AJNewsViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/9.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJNewsViewController.h"
#import "AJRemoteNotification.h"

@interface AJNewsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tbView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) BOOL isLoad;
@end

@implementation AJNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tbView.mj_header = [CTTool makeMJRefeshWithTarget:self andMethod:@selector(loadNews)];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isLoad) {
        _isLoad = YES;
        [self.tbView.mj_header beginRefreshing];
    }
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [AJRemoteNotification checkUserNotificationSetting];
}
- (void)loadNews{
    [self.tbView.mj_header endRefreshing];
    if (self.dataArray.count==0) {
        [self.tbView addNoMessageTipView];
        return;
    }
    [self.view hiddenTipsView];
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
