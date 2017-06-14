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

@interface AJBaseTbViewController : UIViewController<AJTbViewProtocol,AJTbViewDelegateProtocol,AJTbViewDataSourceProtocol>

//列表数据源
@property (strong, nonatomic) NSMutableArray <AJTbViewCellModel *>*dataArray;

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) HouseShowModal showModal;
//调度
@property (strong, nonatomic) AJTbViewPresenter *presenter;
//页面加载一次
@property (assign, nonatomic) BOOL isLoad;

@property (assign, nonatomic) BOOL isDetails;

@property (strong, nonatomic) AVQuery *baseQuery;

//首次从网络请求数据
- (void)initStartData;

@end
