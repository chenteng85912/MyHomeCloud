//
//  CT_PresenterProtocol.h
//  TableView_MVP
//
//  Created by Apple on 2017/1/22.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TableViewInitDataModal) {
    StartInitDataModal,    //初始化数据
    LoadMoreDataModal      //加载更多数据
};

//-------------列表控制器基类代理---------------//
@protocol AJTbViewProtocol <NSObject>

//显示提示视图
- (void)showTipView:(TableViewInitDataModal)type;

//刷新数据
- (void)reloadTableView:(NSArray *)dataArray modal:(TableViewInitDataModal)type;

//重置单元格底部视图
- (void)reStupTableviewFooterView:(NSInteger)pageSize;

@end

//-------------列表控制器子类DataSource代理---------------//
@protocol AJTbViewDataSourceProtocol <UITableViewDataSource>
@optional

//获取数据列表名称
- (NSString *)requestClassName;

//过滤参数
- (NSString *)requestKeyName;

//获取分页大小
- (NSInteger)pageSize;

@end

//-------------列表控制器子类Delegate代理---------------//
@protocol AJTbViewDelegateProtocol <UITableViewDelegate>

//获取子类自定义单元格类名称
- (NSString *)customeTableViewCellClassName;

@optional

//表视图样式
- (UITableViewStyle)tableViewStyle;

//是否集成下拉刷新
- (BOOL)makeMJRefresh;

//是否可以删除
- (BOOL)canDeleteCell;

//数据初始化加成功
- (void)loadDataSuccess;

//单元格高度
- (CGFloat)AJTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

//section数量
- (NSInteger)AJNumberOfSectionsInTableView:(UITableView *)tableView;

@end
