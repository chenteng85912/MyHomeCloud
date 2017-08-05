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
NSInteger const defaultPageSize = 20;

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
    _query = nil;
    if (![_tbViewVC respondsToSelector:@selector(requestClassName)]) {
        return;
    }

    if ([_tbViewVC respondsToSelector:@selector(pageSize)]) {
        _pageSize = [_tbViewVC pageSize];
    }else{
        _pageSize = defaultPageSize;
    }
    
    if ([_tbViewVC respondsToSelector:@selector(canClearLocalCach)]&&[_tbViewVC canClearLocalCach]) {
        [self.query clearCachedResult];
    }
    if ([_tbViewVC respondsToSelector:@selector(canSaveLocalCach)]&&[_tbViewVC canSaveLocalCach]) {
        self.query.cachePolicy = kAVCachePolicyCacheElseNetwork;
    }
    
    [self initPostParameters];
    
    _pageNo = 0;
    self.query.skip = _pageSize *_pageNo;
    //查找对象
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            self.requestState = RequestFailModal;

        }else{
            self.requestState = RequestSuccessModal;
        

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
//请求参数初始化
- (void)initPostParameters{
    
    if(self.showModal==AllHouseModal){
        self.query.className = [_tbViewVC requestClassName];

        
    }else if (self.showModal==SearchHouseModal) {
        NSMutableArray *queryArray = [NSMutableArray new];

        //小区名称
        AVQuery *estate = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
        [estate whereKey:HOUSE_ESTATE_NAME containsString:[_tbViewVC requestKeyName]];
        [queryArray addObject:estate];
        
        //开发商名称
        AVQuery *deve = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
        [deve whereKey:HOUSE_DEVELOPER containsString:[_tbViewVC requestKeyName]];
        [queryArray addObject:deve];
        
        //地区
        AVQuery *area = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
        [area whereKey:HOUSE_AREA containsString:[_tbViewVC requestKeyName]];
        [queryArray addObject:area];
        
        AVQuery *mulQuery = [AVQuery orQueryWithSubqueries:queryArray];
        mulQuery.limit = _pageSize;
        [mulQuery orderByDescending:@"createdAt"];
        self.query = mulQuery;
       
    }else{
        self.query.className = [_tbViewVC requestClassName];
        if ([_tbViewVC requestKeyName]) {
            [self.query whereKey:USER_PHONE equalTo:[_tbViewVC requestKeyName]];
            
        }
        if (self.showModal==ReserverHouseModal) {
            [self.query whereKey:RESERVER_TYPE equalTo:[_tbViewVC reserverTypeName]];
            
        }
        if (self.showModal==UserInclinationModal) {
            [self.query whereKey:ESTATE_TYPE equalTo:[_tbViewVC inclinationTypeName]];
            
        }
    }
    [self addFilter];
   
}
//添加筛选条件
- (void)addFilter{
    
    NSMutableArray *queryArray = [NSMutableArray new];
   
    if ([_tbViewVC respondsToSelector:@selector(filterDic)]) {
        NSDictionary *filterDic = [_tbViewVC filterDic];
        //区域
        NSString *area = filterDic[HOUSE_AREA];
        if (area) {
            AVQuery *areaHouse = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
            [areaHouse whereKey:HOUSE_AREA containsString:area];
            [queryArray addObject:areaHouse];
        }
        //价格
        NSDictionary *priceDic = filterDic[FILTER_PRICE];
        if (priceDic.count>0) {
            AVQuery *areaHouse = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
            if ([[_tbViewVC requestClassName] isEqualToString:SECOND_HAND_HOUSE]) {
                //总价
                if (priceDic[FILTER_MIN]) {
                    [areaHouse whereKey:HOUSE_TOTAL_PRICE greaterThanOrEqualTo:priceDic[FILTER_MIN]];
                    
                }
                if (priceDic[FILTER_MAX]) {
                    [areaHouse whereKey:HOUSE_TOTAL_PRICE lessThan:priceDic[FILTER_MAX]];
                    
                }
                
            }else if ([[_tbViewVC requestClassName] isEqualToString:LET_HOUSE]) {
                //租金
                if (priceDic[FILTER_MIN]) {
                    [areaHouse whereKey:LET_HOUSE_PRICE greaterThanOrEqualTo:priceDic[FILTER_MIN]];
                    
                }
                if (priceDic[FILTER_MAX]) {
                    [areaHouse whereKey:LET_HOUSE_PRICE lessThan:priceDic[FILTER_MAX]];
                    
                }
                
            }else{
                //均价
                if (priceDic[FILTER_MIN]) {
                    [areaHouse whereKey:HOUSE_UNIT_PRICE greaterThanOrEqualTo:priceDic[FILTER_MIN]];
                    
                }
                if (priceDic[FILTER_MAX]) {
                    [areaHouse whereKey:HOUSE_UNIT_PRICE lessThan:priceDic[FILTER_MAX]];
                    
                }
            }
            [queryArray addObject:areaHouse];
        }
        
        //房型
        NSString *rooms = filterDic[HOUSE_AMOUNT];
        if (rooms) {
            AVQuery *areaHouse = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
            [areaHouse whereKey:HOUSE_AMOUNT containsString:rooms];
            [queryArray addObject:areaHouse];
        }
        
        //类型
        NSString *houseType = filterDic[ESTATE_TYPE];
        if (houseType) {
            AVQuery *areaHouse = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
            [areaHouse whereKey:ESTATE_TYPE containsString:houseType];
            [queryArray addObject:areaHouse];
        }
        //更多
        NSDictionary *moreDic = filterDic[FILTER_MORE];
        if (moreDic.count>0) {
            //朝向
            NSString *dir = moreDic[HOUSE_DIRECTION];
            if (dir) {
                AVQuery *areaHouse = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
                [areaHouse whereKey:HOUSE_DIRECTION containsString:dir];
                [queryArray addObject:areaHouse];

            }
            
            //装修
            NSString *des = moreDic[HOUSE_DESCRIBE];
            if (des) {
                AVQuery *areaHouse = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
                [areaHouse whereKey:HOUSE_DESCRIBE containsString:des];
                [queryArray addObject:areaHouse];
                
            }
            
            //楼层情况
//                NSString *floor = moreDic[HOUSE_DESCRIBE];
//                if (floor) {
//                    AVQuery *areaHouse = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
//                    [areaHouse whereKey:HOUSE_DESCRIBE containsString:floor];
//                    [queryArray addObject:areaHouse];
//                    
//                }
            //面积
         
            NSDictionary *areaAgeDic = moreDic[HOUSE_AREAAGE];
            if (areaAgeDic.count>0) {
                AVQuery *areaHouse = [AVQuery queryWithClassName:[_tbViewVC requestClassName]];
                
                if (areaAgeDic[FILTER_MIN]) {
                    [areaHouse whereKey:HOUSE_AREAAGE greaterThanOrEqualTo:areaAgeDic[FILTER_MIN]];
                    
                }
                if (areaAgeDic[FILTER_MAX]) {
                    [areaHouse whereKey:HOUSE_AREAAGE lessThan:areaAgeDic[FILTER_MAX]];
                    
                }
                
                [queryArray addObject:areaHouse];
            }

        }
           
    }
    if (queryArray.count==0) {
        return;
    }
    AVQuery *mulQuery = [AVQuery andQueryWithSubqueries:queryArray];
    mulQuery.limit = _pageSize;
    [mulQuery orderByDescending:@"createdAt"];
    self.query = mulQuery;
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
        _query.cachePolicy = kAVCachePolicyIgnoreCache;
        [_query orderByDescending:@"createdAt"];
    }
    return _query;
}
@end
