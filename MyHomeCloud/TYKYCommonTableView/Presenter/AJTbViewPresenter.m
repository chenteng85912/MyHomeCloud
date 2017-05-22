//
//  CT_TableViewPrensenter.m
//  TableView_MVP
//
//  Created by Apple on 2017/1/22.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "AJTbViewPresenter.h"
#import "AJTbViewCellModel.h"
#import "AJLocalDataCenter.h"

//默认分页大小
NSInteger const defaultPageSize = 50;

@interface AJTbViewPresenter ()

//分页
@property (assign, nonatomic) NSInteger pageNo;
//分页大小  子类里面初始化（默认为50）
@property (assign, nonatomic) NSInteger pageSize;

@property (strong, nonatomic) AVQuery *query;

@end

@implementation AJTbViewPresenter

#pragma mark -AJTbViewPresenterProtocol
- (void)initStartData {
    
    if (![_tbViewVC respondsToSelector:@selector(requestClassName)]) {
        return;
    }
    self.query.className = [_tbViewVC requestClassName];

    if ([_tbViewVC respondsToSelector:@selector(pageSize)]) {
        _pageSize = [_tbViewVC pageSize];
    }else{
        _pageSize = defaultPageSize;
    }

    if ([_tbViewVC respondsToSelector:@selector(requestKeyName)]&&[_tbViewVC requestKeyName]) {
        if ([[_tbViewVC requestKeyName] isEqualToString:USER_PHONE]) {
            [self.query whereKey:[_tbViewVC requestKeyName] equalTo:[AVUser currentUser].mobilePhoneNumber];

        }else{
            //搜索
            //小区名称
            AVQuery *estate = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
            [estate whereKey:HOUSE_ESTATE_NAME containsString:[_tbViewVC requestKeyName]];
            //开发商名称
            AVQuery *deve = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
            [deve whereKey:HOUSE_DEVELOPER containsString:[_tbViewVC requestKeyName]];
            //地区
            AVQuery *area = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
            [area whereKey:HOUSE_AREA containsString:[_tbViewVC requestKeyName]];

            AVQuery *mulQuery = [AVQuery orQueryWithSubqueries:@[estate,deve,area]];
            mulQuery.limit = _pageSize;
            [mulQuery orderByDescending:@"createdAt"];
            self.query = mulQuery;
        }

    }else{
        //先读取本地 后读取网络
        if ([AJLocalDataCenter checkLocalData:HOUSE_INFO ]&&self.query.hasCachedResult) {
            self.query.cachePolicy = kAVCachePolicyCacheOnly;

        }else{
            self.query.cachePolicy = kAVCachePolicyNetworkOnly;

        }
      
    }

    _pageNo = 0;
    self.query.skip = _pageSize *_pageNo;
    if (![self.query.className isEqualToString:HOUSE_INFO]) {
        [self.query includeKey:[NSString stringWithFormat:@"%@.%@",HOUSE_OBJECT,HOUSE_INFO]];

    }
    // 关键代码，同上，会返回 targetAVUser 对应的对象的详细信息，而不仅仅是 objectId

    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            self.requestState = RequestFailModal;

        }else{
            self.requestState = RequestSuccessModal;
            if (![self.query.className isEqualToString:HOUSE_INFO]) {
                [AJLocalDataCenter saveLocalDataTime:HOUSE_INFO];
                
            }

        }
        [_tbViewVC reloadTableView:[self processData:objects]  modal:StartInitDataModal];

        [_tbViewVC showTipView:StartInitDataModal];
        [_tbViewVC reStupTableviewFooterView:self.pageSize];
        if (self.requestState == RequestSuccessModal) {
            if ([self.tbViewVC respondsToSelector:@selector(loadDataSuccess)]) {
                [self.tbViewVC loadDataSuccess];
            }
        }
       
   }];
    
}

- (void)loadMoreData {
    _pageNo++;
    self.query.skip = _pageSize *_pageNo;
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            self.requestState = RequestFailModal;
        }else{
            self.requestState = RequestSuccessModal;
            [_tbViewVC reloadTableView:[self processData:objects]  modal:LoadMoreDataModal];

        }
        [_tbViewVC showTipView:LoadMoreDataModal];
        [_tbViewVC reStupTableviewFooterView:self.pageSize];

    }];

}

//数据处理
- (NSMutableArray <AJTbViewCellModel *> *)processData:(NSArray *)objects{
    NSMutableArray <AJTbViewCellModel *> *dataArray = [NSMutableArray new];
    if (![self.tbViewVC respondsToSelector:@selector(customeTbViewCellModelClassName)]) {
        return dataArray;
    }
    
    for (AVObject *obj in objects) {
        Class modelClass = NSClassFromString([self.tbViewVC customeTbViewCellModelClassName]);
        id <AJTbViewCellModelProtocol> cellModel = [modelClass new];
        AJTbViewCellModel *model = (AJTbViewCellModel *)cellModel;
        model.objectData = obj;
        
        if ([cellModel respondsToSelector:@selector(calculateSizeConstrainedToSize)]) {
            [cellModel calculateSizeConstrainedToSize];
        }
        [dataArray addObject:cellModel];
    }
    return dataArray;
}
#pragma mark -geter and setter
- (AVQuery *)query{
    if (_query ==nil) {
        _query = [AVQuery new];
        _query.limit = _pageSize;
        [_query orderByDescending:@"createdAt"];
    }
    return _query;
}
@end
