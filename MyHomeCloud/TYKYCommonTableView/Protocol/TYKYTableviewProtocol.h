//
//  CT_PresenterProtocol.h
//  TableView_MVP
//
//  Created by Apple on 2017/1/22.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TYKYWebserviceParameters;


typedef NS_ENUM(NSInteger,TableViewInitDataModal) {
    StartInitDataModal,    //初始化数据
    LoadMoreDataModal      //加载更多数据
};


//-------------列表控制器基类代理---------------//
@protocol TYKYTableViewProtocol <NSObject>

//显示提示视图
- (void)showTipView:(TableViewInitDataModal)type;

//刷新数据
- (void)reloadTableView:(NSMutableArray *)dataArray;

//重置单元格底部视图
- (void)reStupTableviewFooterView:(NSInteger)pageSize;

@end

//-------------列表控制器子类DataSource代理---------------//
@protocol TYKYTableViewDataSourceProtocol <UITableViewDataSource>
//获取请求参数
- (NSMutableDictionary *)postBodyParameters;
@optional


//获取http请求地址
- (NSString *)httpsUrlString;

//获取存储到本地的字段
- (NSString *)saveLocalDataKey;

//获取分页大小
- (NSString *)pageSize;

@end


//-------------列表控制器子类Delegate代理---------------//
@protocol TYKYTableViewDelegateProtocol <UITableViewDelegate>
@optional

//获取子类自定义单元格类名称
- (NSString *)customeTableViewCellClassName;

//获取子类自定义单元格模型类名称
- (NSString *)customeCellModelClassName;

//表视图样式
- (UITableViewStyle)tableViewStyle;

//是否集成下拉刷新
- (BOOL)makeMJRefresh;

//数据初始化加成功
- (void)loadDataSuccess;

//单元格高度
- (CGFloat)TYKYTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

//section数量
- (NSInteger)TYKYNumberOfSectionsInTableView:(UITableView *)tableView;
@end
