//
//  CT_RootTableViewController.m
//  TableView_MVP
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "AJBaseTbViewController.h"
#import "AJTbViewCellModel.h"
#import "UITableView+NoMoreDataInFooter.h"
#import <MJRefresh/MJRefresh.h>
#import "AJFilterViewController.h"

@interface AJBaseTbViewController ()<UIGestureRecognizerDelegate>

//上一次单元格数量
@property (assign, nonatomic) NSInteger oldDataNum;
//是否集成下拉刷新
@property (assign, nonatomic) BOOL mjRefresh;
//动画
@property (assign, nonatomic) BOOL isAnimate;
@property (strong, nonatomic) AJFilterViewController *filterVC;

@end

@implementation AJBaseTbViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self initTableView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //去除导航栏黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController setNavigationBarHidden:_isDetails animated:YES];
    if (_isDetails) {
        return;
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = NavigationBarColor;
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if (self.navigationItem.leftBarButtonItem) {
        return;
    }
    
    //添加返回键
    if (self.navigationController.viewControllers.count<2&&!self.navigationController.presentingViewController) {
        self.navigationItem.leftBarButtonItem = nil;
        
    }else{
        UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIImage *backImg = [UIImage imageNamed:@"close"];
        if (self.navigationController.viewControllers.count>1) {
            backImg = [UIImage imageNamed:@"back"];
        }
        [left setImage:backImg forState:UIControlStateNormal];
        left.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        
        [left addTarget:self action:@selector(backToPreVC) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!_isLoad) {
        if (self.isDetails) {
            self.tableView.frame = CGRectMake(0, 0, dWidth, dHeight-50);

        }
//        else{
//            self.tableView.frame = self.view.bounds;
//
//        }

        [self.tableView showHUD:nil];
        [self initStartData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark - TableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self respondsToSelector:@selector(AJNumberOfSectionsInTableView:)]) {
        return [self AJNumberOfSectionsInTableView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AJTbViewCellModel <AJTbViewCellModelProtocol> *model = self.dataArray[indexPath.row];
    
    id <AJTbViewCellProtocol> cell = [tableView dequeueReusableCellWithIdentifier:[self customeTbViewCellClassName]];
    
    [cell processCellData:model];
    
    return (UITableViewCell*)cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(AJTableView:heightForRowAtIndexPath:)]) {
        return  [self AJTableView:tableView heightForRowAtIndexPath:indexPath];
        
    }
    AJTbViewCellModel *model = self.dataArray[indexPath.row];
    return model.cellHeight;

}
#pragma mark - UITableViewDelegate

#pragma mark - TYKYTableViewProtocol
//重置上拉刷新
- (void)reStupTableviewFooterView:(NSInteger)pageSize{
    
    
    self.tableView.tableFooterView = nil;

    if (self.dataArray.count%pageSize) {
        if (self.dataArray.count>0) {
            //添加无更多数据的提示
            [self.tableView noticeNoMoreData];

        }
    }else{
        if (_oldDataNum!=self.dataArray.count) {
            _oldDataNum = self.dataArray.count;
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

        }else{
            self.tableView.mj_footer = nil;
            if (self.dataArray.count>0) {
                //添加无更多数据的提示
                [self.tableView noticeNoMoreData];
            }
        }
        
    }
}
//刷新数据
- (void)reloadTableView:(NSArray *)dataArray modal:(TableViewInitDataModal)type{
    [self.tableView removeHUD];
    if (type==StartInitDataModal) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:dataArray];
    [self.tableView reloadData];

    if ([self respondsToSelector:@selector(firstShowAnimation)]) {
        if ([self firstShowAnimation]) {
            if (!_isAnimate) {
                _isAnimate = YES;
                [self.tableView showViewWithAnimation];
                
            }
        }
    }
   
}
//添加提示
- (void)showTipView:(TableViewInitDataModal)type{
    if (_mjRefresh) {
        [self.tableView.mj_header endRefreshing];
        
    }
    [self.tableView hiddenTipsView];
    if (type==StartInitDataModal) {
        switch (self.presenter.requestState) {
            case RequestSuccessModal:{
                if (self.dataArray.count==0) {
                    [self.tableView addNoDataTipView];
                    self.tableView.mj_footer = nil;
                }
            }
                break;
            case RequestTimeOutModal:{
               
            }
                break;
            case RequestFailModal:{
                [self.tableView addFailDataTipView];
                self.tableView.mj_footer = nil;

            }
                break;
            case NetworkHaveProblom:
            {

                [self.tableView addInternetErrorTipView];
                self.tableView.mj_footer = nil;

            }
                
                break;
            default:
                break;
        }
    }else{
        switch (self.presenter.requestState) {
            case RequestTimeOutModal:
            case RequestFailModal:{
               [self.view showTips:@"请求数据失败" withState:TYKYHUDModeFail complete:nil];

            }
                break;
            case NetworkHaveProblom:{
               [self.view showTips:@"您似乎断开了网络连接" withState:TYKYHUDModeFail complete:nil];
            }
                
                break;
            default:
                break;
        }

    }
}
#pragma mark -private methods 列表初始化
- (void)initTableView{
    
    [self.view addSubview:self.tableView];
    if (_showFilter) {
        self.tableView.frame = CGRectMake(0, 40, dWidth, dHeight-64-40);
        [self.view addSubview:self.filterVC.view];
    }
    if ([self respondsToSelector:@selector(customeTbViewCellClassName)]) {
        [self.tableView registerNib:[UINib nibWithNibName:[self customeTbViewCellClassName] bundle:nil] forCellReuseIdentifier:[self customeTbViewCellClassName]];

    }
    
    if ([self respondsToSelector:@selector(makeMJRefresh)]) {
        _mjRefresh = [self makeMJRefresh];
        if (_mjRefresh) {
            self.tableView.mj_header = [self makeMJRefeshWithTarget:self andMethod:@selector(initStartData)];

        }
        
    }
    if ([self respondsToSelector:@selector(canDeleteCell)]&&[self canDeleteCell]) {
        //长按手势
        UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPressGr.minimumPressDuration = 0.2;
        [self.tableView addGestureRecognizer:longPressGr];
    }

}
- (void)backToPreVC{
    
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (self.navigationController.presentingViewController) {
        
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognize
{
    if (self.navigationController.viewControllers.count==0) {
        return NO;
    }else{
       
        return YES;
    }
}
#pragma mark -private methods 加载数据
//首次从网络请求数据
- (void)initStartData{
    if (!_isLoad) {
        _isLoad = YES;

    }
    _oldDataNum = 0;
    [self.presenter initStartData];
}
//请求更多数据
- (void)loadMoreData{
    [self.presenter loadMoreData];
}
#pragma mark -private methods 设置明杰刷新
- (MJRefreshNormalHeader *)makeMJRefeshWithTarget:(id)root andMethod:(SEL)methodName{
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc]init];
    [header setTitle:@"继续下拉以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;

    header.stateLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14];
    header.stateLabel.textColor = [UIColor blackColor];
    
    header.refreshingTarget = root;
    header.refreshingAction = methodName;
    return header;
}
//长按手势
-(void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        if(indexPath == nil){
            return ;
            
        }
        [self showAlertView:indexPath];
    }
}
- (void)showAlertView:(NSIndexPath *)indexPath{
    WeakSelf;
    NSString *message;
    if (self.showModal==UserFavoriteModal) {
        message = @"确定删除此条关注记录?";
    }else if (self.showModal==UserRecordModal) {
        message = @"确定删除此条浏览记录?";
    }else if (self.showModal==ReserverHouseModal) {
        message = @"确定删除此预约信息?";
    }else{
        message = @"确定删除该房源信息?";
    }
    [UIAlertController alertWithTitle:@"温馨提示" message:message cancelButtonTitle:@"取消" otherButtonTitles:@[@"删除"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            AJTbViewCellModel *model = weakSelf.dataArray[indexPath.row];
            [weakSelf.view showHUD:@"正在删除..."];
            [model.objectData deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [weakSelf.view removeHUD];
                if (!succeeded) {
                    [weakSelf.view showTips:@"网络错误,请重试" withState:TYKYHUDModeFail complete:nil];
                    return;
                }
                
                //删除我的房源
                if (self.showModal==MyHouseModal) {
//                    [weakSelf deleteRecordData:model.subObj];
                    //删除图片文件
                    NSArray *fileArray = model.objectData[HOUSE_FILE_ID];
                    for (NSString *fileId in fileArray) {
                        [AJSB deleteFile:fileId complete:nil];
                    }

                }
                
                [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [weakSelf reStupTableviewFooterView:50];
                if (weakSelf.dataArray.count==0) {
                    [weakSelf.tableView addNoDataTipView];
                }
                
                
            }];
        }else{
            [self.tableView setEditing:NO animated:YES];
        }
    }];
    
}
#pragma mark - getters and setters
- (NSMutableArray <AJTbViewCellModel *>*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (!_tableView) {
        UITableViewStyle tbViewStyle = UITableViewStylePlain;
        if ([self respondsToSelector:@selector(tableViewStyle)]) {
            tbViewStyle = [self tableViewStyle];
            
        }
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:tbViewStyle];
               _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;

        
    }
    return _tableView;
}
- (AJTbViewPresenter *)presenter{
    if (!_presenter) {
        _presenter = [AJTbViewPresenter new];
        _presenter.tbViewVC = self;
        _presenter.showModal = self.showModal;
    }
    return _presenter;
}
- (AVQuery *)baseQuery{
    if (_baseQuery==nil) {
        _baseQuery = [AVQuery new];
        //        _baseQuery.cachePolicy = kAVCachePolicyCacheElseNetwork;
        _baseQuery.limit = 50;;
        [_baseQuery orderByDescending:@"createdAt"];
        
    }
    return _baseQuery;
}
- (AJFilterViewController *)filterVC{
    if (_filterVC ==nil) {
        _filterVC = [AJFilterViewController new];
        _filterVC.className = _className;
        _filterVC.view.frame = CGRectMake(0, 0, dWidth, 40+64);

        [self addChildViewController:_filterVC];
    }
    return _filterVC;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
