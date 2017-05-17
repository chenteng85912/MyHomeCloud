//
//  CT_TableViewPrensenter.m
//  TableView_MVP
//
//  Created by Apple on 2017/1/22.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "AJTbViewPresenter.h"
#import "AJTbViewCellModel.h"

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
    if ([_tbViewVC respondsToSelector:@selector(pageSize)]) {
        _pageSize = [_tbViewVC pageSize];
    }else{
        _pageSize = defaultPageSize;
    }
    
    if ([_tbViewVC respondsToSelector:@selector(requestKeyName)]&&[_tbViewVC requestKeyName]) {
        [self.query whereKey:[_tbViewVC requestKeyName] equalTo:[AVUser currentUser].mobilePhoneNumber];

    }

    _pageNo = 0;
    self.query.className = [_tbViewVC requestClassName];
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
            if ([self.tbViewVC respondsToSelector:@selector(loadDataSuccess)]) {
                [self.tbViewVC loadDataSuccess];
            }

        }
        [_tbViewVC reloadTableView:[self processData:objects]  modal:StartInitDataModal];

        [_tbViewVC showTipView:StartInitDataModal];
        
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
//        _query.cachePolicy = kAVCachePolicyCacheElseNetwork;
        _query.limit = _pageSize;
        [_query orderByDescending:@"createdAt"];
    }
    return _query;
}
@end
