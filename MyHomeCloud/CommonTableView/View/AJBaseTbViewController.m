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

@interface AJBaseTbViewController ()<UIGestureRecognizerDelegate>

//上一次单元格数量
@property (assign, nonatomic) NSInteger oldDataNum;
//是否集成下拉刷新
@property (assign, nonatomic) BOOL mjRefresh;
//动画
@property (assign, nonatomic) BOOL isAnimate;

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

        }else{
            self.tableView.frame = self.view.bounds;

        }

        [self.tableView showHUD:nil];
        [self initStartData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
//删除浏览记录 用户收藏 图片文件
- (void)deleteRecordData:(AVObject *)obj{
    
    self.baseQuery.className = [self recordClassName];
    [self.baseQuery whereKey:HOUSE_ID   equalTo:obj.objectId];

    WeakSelf;
    //删除浏览记录
    [self.baseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            for (AVObject *obje in objects) {
                [obje deleteInBackground];
            }
        }
        //删除收藏
        weakSelf.baseQuery.className = [self favoriteClassName];
        [weakSelf.baseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (objects.count>0) {
                for (AVObject *obje in objects) {
                    [obje deleteInBackground];
                }
            }
        }];
    }];
    
    //删除文件
    NSArray *fileArray = obj[HOUSE_FILE_ID];
    for (NSString *fileId in fileArray) {
        [AJSB deleteFile:fileId complete:nil];
    }
    
}
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
    [UIAlertController alertWithTitle:@"温馨提示" message:@"确定删除该房源?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"删除"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            AJTbViewCellModel *model = weakSelf.dataArray[indexPath.row];
            [weakSelf.view showHUD:@"正在删除..."];
            [model.objectData deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [weakSelf.view removeHUD];
                if (!succeeded) {
                    [weakSelf.view showTips:@"网络错误,请重试" withState:TYKYHUDModeFail complete:nil];
                    return;
                }
                
                //删除浏览记录 收藏数据
                if (self.showModal==MyHouseModal) {
                    [weakSelf deleteRecordData:model.subObj];
                    
                }
                
                [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
