//
//  CT_TableViewPrensenter.m
//  TableView_MVP
//
//  Created by Apple on 2017/1/22.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "TYKYTableViewPresenter.h"
#import "TYKYWebserviceParameters.h"

NSString *const PAGENO = @"PAGENO";
NSString *const PAGESIZE = @"PAGESIZE";

//默认分页大小
NSString *const defaultPageSize = @"50";

@interface TYKYTableViewPresenter ()

//网络请求参数
@property (strong, nonatomic) NSMutableDictionary *requestParameters;
//分页
@property (assign, nonatomic) NSInteger pageNo;
//分页大小  子类里面初始化（默认为50）
@property (strong, nonatomic) NSString *pageSize;
//读取本地数据
@property (assign, nonatomic) BOOL readLocal;
//本地数据存储字段
@property (strong, nonatomic) NSString *saveLocalKey;

@end

@implementation TYKYTableViewPresenter

#pragma mark -TYKYTableViewPresenterProtocol
- (void)initStartData {
    
    if ([_tbViewVC respondsToSelector:@selector(saveLocalDataKey)]) {
        _saveLocalKey = [_tbViewVC saveLocalDataKey];
    }
    if ([_tbViewVC respondsToSelector:@selector(pageSize)]) {
        _pageSize = [_tbViewVC pageSize];
    }else{
        _pageSize = defaultPageSize;
    }
  
    
    //第一次进入 读取本地数据
    if (!_readLocal) {
        _readLocal = YES;
        if (_saveLocalKey&&![self.tableViewRepository checkLocalData:_saveLocalKey]) {
            [self.tableViewData initLocalData:[self.tableViewRepository readLocalData:_saveLocalKey]];
            if (self.tableViewData.dataSourceArray.count>0) {
                [_tbViewVC reloadTableView:self.tableViewData.dataSourceArray];
                [_tbViewVC showTipView:StartInitDataModal];
                return;
            }
        }

    }
    
    _pageNo = 1;
    [self.requestParameters setObject:[NSString stringWithFormat:@"%ld",(long)_pageNo] forKey:PAGENO];
    
    if ([_tbViewVC respondsToSelector:@selector(postBodyParameters)]) {

        NSDictionary *dic = [_tbViewVC postBodyParameters];
        [self.requestParameters setValuesForKeysWithDictionary:dic];

    }
    
    debugLog(@"请求参数：%@",self.requestParameters);
    __weak typeof(self) weakSelf = self;

   [self fetchDataComplete:^(NSError *error, id objectDic) {
     
       [weakSelf.tableViewData initStartTableViewData:objectDic error:error];
       [weakSelf.tbViewVC reloadTableView:self.tableViewData.dataSourceArray];
       [weakSelf.tbViewVC showTipView:StartInitDataModal];
       [weakSelf.tbViewVC reStupTableviewFooterView:_pageSize.integerValue];
       
       //存储本地数据
       if (_saveLocalKey) {
           [weakSelf.tableViewRepository saveLocalData:weakSelf.tableViewData.saveLocalDataArray forKey:_saveLocalKey];

       }
       if ([weakSelf.tbViewVC respondsToSelector:@selector(loadDataSuccess)]) {
           [weakSelf.tbViewVC loadDataSuccess];
       }
       
   }];
    
}

- (void)loadMoreData {
    _pageNo++;
    [self.requestParameters setObject:[NSString stringWithFormat:@"%ld",(long)_pageNo] forKey:PAGENO];

    __weak typeof(self) weakSelf = self;
    [self fetchDataComplete:^(NSError *error, NSDictionary *objectDic) {
        [weakSelf.tableViewData initMoreTableViewData:objectDic];
        [weakSelf.tbViewVC reloadTableView:self.tableViewData.dataSourceArray];
        
        [weakSelf.tbViewVC showTipView:LoadMoreDataModal];
        [weakSelf.tbViewVC reStupTableviewFooterView:_pageSize.integerValue];

    }];
}


- (void)deleteCell:(NSInteger)index{
    
    [self.tableViewData.saveLocalDataArray removeObjectAtIndex:index];
    [self.tableViewRepository saveLocalData:self.tableViewData.saveLocalDataArray forKey:_saveLocalKey];
    [self.tbViewVC showTipView:StartInitDataModal];

}
#pragma mark -请求网络
- (void)fetchDataComplete:(void(^)(NSError *error, id objectDic))afterRequest{
    if (![_tbViewVC respondsToSelector:@selector(httpsUrlString)]) {
        if (afterRequest) {
            afterRequest(nil,nil);
        }
        return;
    }
    [self.requestParameters removeObjectForKey:PAGESIZE];
    [self.requestParameters removeObjectForKey:PAGENO];
    [self.requestParameters setObject:_pageSize forKey:@"pageSize"];
    [self.requestParameters setObject:[NSString stringWithFormat:@"%ld",(long)_pageNo] forKey:@"pageNo"];
    [self.tableViewRepository fetchDataWithUrlStr:[_tbViewVC httpsUrlString]
                                   bodyParameters:self.requestParameters
                                         complete:^(NSError *error, id objectDic) {
                                             if (afterRequest) {
                                                 afterRequest(error,objectDic);
                                             }
                                         }];
        
    
}

#pragma mark -geter and setter
- (NSMutableDictionary *)requestParameters{
    if (!_requestParameters) {
        _requestParameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:_pageSize,PAGESIZE, nil];
        
    }
    return _requestParameters;
}
- (TYKYTableViewModel <TYKYTableViewModelProtocol>*)tableViewData{
    if (!_tableViewData) {
        _tableViewData = [TYKYTableViewModel new];
        if ([_tbViewVC respondsToSelector:@selector(customeCellModelClassName)]) {
            _tableViewData.customeCellModelName = [_tbViewVC customeCellModelClassName];
            
        }
    }
    
    return _tableViewData;
}

- (TYKYTableViewRepository *)tableViewRepository {
    if (!_tableViewRepository) {
        _tableViewRepository = [TYKYTableViewRepository new];
    }
    return _tableViewRepository;
}

@end
