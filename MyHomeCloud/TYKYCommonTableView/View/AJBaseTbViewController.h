//
//  CT_RootTableViewController.h
//  TableView_MVP
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJTbViewProtocol.h"
#import "AJTbViewPresenter.h"
#import "AJTbViewCellProtocol.h"
#import "AJTbViewPresenterProtocol.h"


@class AJTbViewCellModel;

@interface AJBaseTbViewController : CTBaseViewController<AJTbViewProtocol,AJTbViewDelegateProtocol,AJTbViewDataSourceProtocol>

//列表数据源
@property (strong, nonatomic) NSMutableArray <AJTbViewCellModel *>*dataArray;

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) MYHouseShowModal showModal;
//调度
@property (strong, nonatomic) AJTbViewPresenter *presenter;
//页面加载一次
@property (assign, nonatomic) BOOL isLoad;
//首次从网络请求数据
- (void)initStartData;

@end
