//
//  CT_TableViewModel.m
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "TYKYTableViewModel.h"
#import "TYKYTableViewCellModel.h"

NSString *const RETURNVALUE_KEY  =  @"ReturnValue";
NSString *const TABLE_CODE_KEY   =  @"code";
NSString *const MESSAGE_KEY  =  @"msg";
NSString *const TABLE_ERROR_KEY  =  @"error";
NSInteger const SUCCESSCODE_KEY  = 200;
NSInteger const TIMEOUTCODE_KEY  = 401;
NSString *const DATA_KEY  =   @"data";
NSString *const FAIL_REQUEST = @"数据加载失败，请重试";
NSString *const TIMEOUT_MESSAGE  = @"请求超时，请重新登录";

@implementation TYKYTableViewModel

#pragma mark -geter and setter
- (NSMutableArray *)saveLocalDataArray {
    if (!_saveLocalDataArray) {
        _saveLocalDataArray = [NSMutableArray new];
    }
    return _saveLocalDataArray;
}
- (NSMutableArray <TYKYTableViewCellModel*>*)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray new];
        
    }
    return _dataSourceArray;
}
#pragma mark -TYKYTableViewModelProtocol
//初始化数据
- (void)initStartTableViewData:(id)tbViewData error:(NSError *)error{
    if (error.code==-1009) {
        self.requestState = NetworkHaveProblom;
    }
   
    [self.dataSourceArray removeAllObjects];
    [self.saveLocalDataArray removeAllObjects];
    [self initData:tbViewData];
}
//加载更多数据
- (void)initMoreTableViewData:(id)tbViewData{
    [self initData:tbViewData];
}
//加载本地数据
- (void)initLocalData:(NSArray *)localArray{
    [self.dataSourceArray removeAllObjects];
    [self.saveLocalDataArray removeAllObjects];
    [self.saveLocalDataArray addObjectsFromArray:localArray];
    [self initCellData:localArray];
    
}

#pragma mark -数据处理
- (void)initData:(id)tbViewData{
    debugLog(@"%@",tbViewData);
    if (![tbViewData isKindOfClass:[NSDictionary class]]) {
        return;
    }
  
    _message = [tbViewData valueForKey:MESSAGE_KEY];
    _error = [tbViewData valueForKey:TABLE_ERROR_KEY];
    _code = [tbViewData valueForKey:TABLE_CODE_KEY];
    
    if (_code.integerValue==SUCCESSCODE_KEY) {
        _requestState = RequestSuccessModal;
    }else if (_code.integerValue==TIMEOUTCODE_KEY){
        _requestState = RequestTimeOutModal;
        if (!_error) {
            _error = TIMEOUT_MESSAGE;
        }
    }else{
        _requestState = RequestFailModal;
        if (!_error) {
            _error = FAIL_REQUEST;
        }
    }
    NSLog(@"列表网络请求状态-----:%ld",(long)_requestState);
    NSLog(@"列表网络请求状态码-----:%@",_code);

    id value = [tbViewData valueForKey:RETURNVALUE_KEY];
    if (!value) {
        value = [tbViewData valueForKey:DATA_KEY];
    }

    if ([value isKindOfClass:[NSArray class]]) {
        if (self.saveLocalDataArray.count==0) {
            [self.saveLocalDataArray addObjectsFromArray:value];
        }
        [self initCellData:value];
    }
  }

//生成数据模型
- (void)initCellData:(NSArray *)dataArray{
    if (!dataArray||dataArray.count==0) {
        return;
    }
    NSLog(@"列表数据数量:------%lu",(unsigned long)dataArray.count);
    if (!_customeCellModelName) {
        return;
    }
    for (id valueData in dataArray) {
        if (![valueData isKindOfClass:[NSDictionary class]]) {
            NSLog(@"单元格数据不是字典类型");
            return;
        }
        Class  aclass = NSClassFromString(_customeCellModelName);
        if (aclass)
        {
            id <TYKYTableViewCellModelProtocol> cellModel = [aclass new];
            if ([cellModel respondsToSelector:@selector(initValueWithDictionary:)]) {
                cellModel = [cellModel initValueWithDictionary:valueData];
                if ([cellModel respondsToSelector:@selector(calculateSizeConstrainedToSize)]) {
                    [cellModel calculateSizeConstrainedToSize];
                    
                }
            }
            [self.dataSourceArray addObject:cellModel];
            
        }
        
    }

}
//字典过滤
//- (NSMutableDictionary *)fitterDic:(NSDictionary *)dic{
//    NSMutableDictionary *newDic = [dic mutableCopy];
//    for (NSString *key in newDic.allKeys) {
//        id value = newDic[key];
//        if (!value|[value isKindOfClass:[NSNull class]]) {
//            [newDic setObject:@"" forKey:key];
//        }
//    }
//    return newDic;
//}
@end
