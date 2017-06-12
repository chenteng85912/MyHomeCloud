//
//  AJHomeDataCenter.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/10.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHomeDataCenter.h"
#import "AJTbViewCellModel.h"
#import "AJSecondHouseCellModel.h"
#import "AJLetHouseCellModel.h"
#import "AJNewHouseModel.h"

NSInteger const MAX_NUM = 5;
@interface AJHomeDataCenter ()

@property (strong, nonatomic) AVQuery *query;

@end

@implementation AJHomeDataCenter

- (void)fetchSecondHouseDataCompleteHander:(RequestBlock)afterRequest{
    self.query.className = SECOND_HAND_HOUSE;
    [self.query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects&&afterRequest) {
            NSArray *dataArray = [self processData:objects className:NSStringFromClass([AJSecondHouseCellModel class])];
            afterRequest(YES,dataArray);
        }
        
    }];
}

- (void)fetchLetHouseDataCompleteHander:(RequestBlock)afterRequest{
    self.query.className = LET_HOUSE;

    [self.query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSArray *dataArray = [self processData:objects className:NSStringFromClass([AJLetHouseCellModel class])];
        afterRequest(YES,dataArray);

    }];
}

- (void)fetchNewHouseDataCompleteHander:(RequestBlock)afterRequest{
    self.query.className = N_HOUSE;

    [self.query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects&&afterRequest) {
            NSArray *dataArray = [self processData:objects className:NSStringFromClass([AJNewHouseModel class])];
            afterRequest(YES,dataArray);
        }
    }];
}
//数据处理
- (NSMutableArray*)processData:(NSArray *)objects className:(NSString *)className{
    NSMutableArray *dataArray = [NSMutableArray new];
    
    for (AVObject *obj in objects) {
        AJTbViewCellModel *modal = (AJTbViewCellModel *)[NSClassFromString(className)  new];
        modal.objectData = obj;
        
        if ([modal respondsToSelector:@selector(calculateSizeConstrainedToSize)]) {
            [modal calculateSizeConstrainedToSize];
        }
        [dataArray addObject:modal];
    }
    return dataArray;
}
//保存浏览记录
- (void)addRecordData:(AVObject *)object objectClassName:(NSString *)className recordClassName:(NSString *)recordClassName{
    if (![AVUser currentUser]) {
        return;
    }
    AVObject *houseInfo = [[AVObject alloc] initWithClassName:recordClassName];
    [houseInfo setObject:object.objectId        forKey:HOUSE_ID];
    
    [houseInfo setObject:[AVUser currentUser].mobilePhoneNumber forKey:USER_PHONE];
    
    [houseInfo setObject:[AVObject objectWithClassName:className objectId:object.objectId] forKey:HOUSE_OBJECT];
    [houseInfo setObject:[AVUser currentUser].objectId  forKey:HOUSE_AUTHOR];
    [houseInfo setObject:[AVUser currentUser][HEAD_URL] forKey:HEAD_URL];
    
    self.query.className = recordClassName;
    [self.query whereKey:HOUSE_ID equalTo:object.objectId];
    [self.query whereKey:USER_PHONE equalTo:[AVUser currentUser].mobilePhoneNumber];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            return;
            
        }
        [houseInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                
            }
        }];
    }];
}
#pragma mark -geter and setter
- (AVQuery *)query{
    if (_query ==nil) {
        _query = [AVQuery new];
        _query.limit = MAX_NUM;
        _query.skip = 0;
        _query.cachePolicy = kAVCachePolicyIgnoreCache;
        [_query orderByDescending:@"createdAt"];
    }
    return _query;
}
@end
