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
//添加收藏
- (void)addFavoriteData:(AVObject *)object favClassName:(NSString *)favClassName complete:(RequestBlock)afterRequest{
    AVObject *houseData = [self creatHouseInfo:object withClassName:favClassName];
    [houseData saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (afterRequest) {
            afterRequest(succeeded,nil);
        }
        
    }];
}
//保存浏览记录
- (void)addRecordData:(AVObject *)object recordClassName:(NSString *)recordClassName{
    if (![AVUser currentUser]) {
        return;
    }
    AVObject *houseData = [self creatHouseInfo:object withClassName:recordClassName];
    
    self.query.className = recordClassName;
    [self.query whereKey:HOUSE_ID equalTo:object.objectId];
    [self.query whereKey:USER_PHONE equalTo:[AVUser currentUser].mobilePhoneNumber];
    //先查询是否已经保存
    [self.query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            return;
            
        }
        [houseData saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                
            }
        }];
    }];
}
- (AVObject *)creatHouseInfo:(AVObject *)object withClassName:(NSString *)className{
    AVObject *houseData = [[AVObject alloc] initWithClassName:className];
    
    [houseData setObject:object.objectId        forKey:HOUSE_ID];
    
    [houseData setObject:[AVUser currentUser].mobilePhoneNumber      forKey:USER_PHONE];
    [houseData setObject:object[HOUSE_AMOUNT]               forKey:HOUSE_AMOUNT];
    [houseData setObject:object[HOUSE_AREAAGE]              forKey:HOUSE_AREAAGE];
    [houseData setObject:object[HOUSE_ESTATE_NAME]                forKey:HOUSE_ESTATE_NAME];
    [houseData setObject:object[HOUSE_THUMB]                forKey:HOUSE_THUMB];
    
    if ([className isEqualToString:LET_RECORD]||[className isEqualToString:LET_FAVORITE]) {
        //租金
        [houseData setObject:object[LET_HOUSE_PRICE]         forKey:LET_HOUSE_PRICE];
        [houseData setObject:object[HOUSE_DIRECTION]           forKey:HOUSE_DIRECTION];
        
    }else if ([className isEqualToString:SECOND_RECORD]||[className isEqualToString:SECOND_FAVORITE]){
        //总价
        [houseData setObject:object[HOUSE_TOTAL_PRICE]       forKey:HOUSE_TOTAL_PRICE];
        //房屋单价
        [houseData setObject:object[HOUSE_UNIT_PRICE]        forKey:HOUSE_UNIT_PRICE];
        [houseData setObject:object[HOUSE_DESCRIBE]            forKey:HOUSE_DESCRIBE];
        
    }else{
        //总价
        [houseData setObject:object[HOUSE_TOTAL_PRICE]       forKey:HOUSE_TOTAL_PRICE];
        //房屋单价
        [houseData setObject:object[HOUSE_UNIT_PRICE]        forKey:HOUSE_UNIT_PRICE];
    }
    return houseData;
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
