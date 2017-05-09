//
//  CT_RootTableViewController.m
//  TableView_MVP
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "TYKYBaseTableViewController.h"
#import "TYKYTableViewCellModel.h"
#import "TYKYTableviewProtocol.h"
#import "UITableView+NoMoreDataInFooter.h"
#import <MJRefresh/MJRefresh.h>

@interface TYKYBaseTableViewController ()

//上一次单元格数量
@property (assign, nonatomic) NSInteger oldDataNum;
//是否集成下拉刷新
@property (assign, nonatomic) BOOL mjRefresh;

@property (assign, nonatomic) BOOL networkOk;//有网络


@end

@implementation TYKYBaseTableViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self initTableView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    if (!_isLoad) {
        _isLoad = YES;

        if ([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleLightContent) {
            self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49);

        }else{
            self.tableView.frame = self.view.bounds;

        }
//        if (self.dataArray.count>0) {
//            [self.tableView reloadData];
//            return;
//        }
        if (_mjRefresh) {
            [self.tableView.mj_header beginRefreshing];

        }else{
            [self initStartData];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - TableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self respondsToSelector:@selector(TYKYNumberOfSectionsInTableView:)]) {
        return [self TYKYNumberOfSectionsInTableView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(TYKYTableView:heightForRowAtIndexPath:)]) {
        return  [self TYKYTableView:tableView heightForRowAtIndexPath:indexPath];
        
    }
    TYKYTableViewCellModel <TYKYTableViewCellModelProtocol> *model = self.dataArray[indexPath.row];
    return model.cellHeight;

}

#pragma mark - TYKYTableViewProtocol
//重置上拉刷新
- (void)reStupTableviewFooterView:(NSInteger)pageSize{
    
    if (!_mjRefresh) {
        return;
    }
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
- (void)reloadTableView:(NSMutableArray *)dataArray{
    if (_mjRefresh) {
        [self.tableView.mj_header endRefreshing];

    }

    self.dataArray = dataArray;
    [self.tableView reloadData];

}
//添加提示
- (void)showTipView:(TableViewInitDataModal)type{
    
    [self.tableView hiddenTipsView];
    if (type==StartInitDataModal) {
        switch (_presenter.tableViewData.requestState) {
            case RequestSuccessModal:{
                if (self.dataArray.count==0) {
                    [self.tableView addNoDataTipView];
                    self.tableView.mj_footer = nil;
                }
            }
                break;
            case RequestTimeOutModal:{
                [self.tableView addTipView:self.presenter.tableViewData.error];
               
            }
                break;
            case RequestFailModal:{
                self.networkOk = NO;
                [self.tableView addFailDataTipView];
                self.tableView.mj_footer = nil;

            }
                break;
            case NetworkHaveProblom:
            {
                self.networkOk = NO;

                [self.tableView addInternetErrorTipView];
                self.tableView.mj_footer = nil;

            }
                
                break;
            default:
                break;
        }
    }else{
        switch (_presenter.tableViewData.requestState) {
            case RequestSuccessModal:{
                
            }
                
                break;
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
    
    if ([self respondsToSelector:@selector(customeTableViewCellClassName)]) {
        [self.tableView registerNib:[UINib nibWithNibName:[self customeTableViewCellClassName] bundle:nil] forCellReuseIdentifier:[self customeTableViewCellClassName]];
        
    }
    if ([self respondsToSelector:@selector(makeMJRefresh)]) {
        _mjRefresh = YES;
        self.tableView.mj_header = [self makeMJRefeshWithTarget:self andMethod:@selector(initStartData)];
        
    }

}

#pragma mark -private methods 加载数据
//首次从网络请求数据
- (void)initStartData{
    
    //获取列表数据，网络请求、或者到本地去取
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
//    header.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"Avenir-Book" size:10];
//    header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];

    header.stateLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14];
    header.stateLabel.textColor = [UIColor blackColor];
    
    header.refreshingTarget = root;
    header.refreshingAction = methodName;
    return header;
}

#pragma mark - getters and setters
- (NSMutableArray <TYKYTableViewCellModel *>*)dataArray{
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
        
    }
    return _tableView;
}
- (TYKYTableViewPresenter *)presenter{
    if (!_presenter) {
        _presenter = [TYKYTableViewPresenter new];
        _presenter.tbViewVC = self;
    }
    return _presenter;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
