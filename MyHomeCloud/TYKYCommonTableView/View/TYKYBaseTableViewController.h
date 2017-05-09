//
//  CT_RootTableViewController.h
//  TableView_MVP
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTBaseViewController.h"
#import "TYKYTableviewProtocol.h"
#import "TYKYTableViewPresenterProtocol.h"
#import "TYKYTableViewPresenter.h"
#import "TYKYWebserviceParameters.h"

@class TYKYTableViewCellModel;

@interface TYKYBaseTableViewController : CTBaseViewController<TYKYTableViewDataSourceProtocol,TYKYTableViewDelegateProtocol,TYKYTableViewProtocol>

//列表数据源
@property (strong, nonatomic) NSMutableArray <TYKYTableViewCellModel *>*dataArray;

@property (strong, nonatomic) UITableView *tableView;

//调度
@property (strong, nonatomic) TYKYTableViewPresenter *presenter;
//页面加载一次
@property (assign, nonatomic) BOOL isLoad;
//首次从网络请求数据
- (void)initStartData;

@end
