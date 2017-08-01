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
#import "AJNewHouseCellModel.h"

NSInteger const MAX_NUM = 100;
NSInteger const SHOW_NUM = 5;

@interface AJHomeDataCenter ()

@end

@implementation AJHomeDataCenter

- (void)fetchHomeHeadDataCompleteHander:(RequestBlock)afterRequest{
    AVQuery *query = [self creatQuety];
    query.className  = AJCLOUD_INFO;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (objects.count>0) {
            
            afterRequest(YES,objects);
        }else{
            afterRequest(NO,nil);
            
        }
    }];
}
- (void)fetchSecondHouseDataCompleteHander:(RequestBlock)afterRequest{

    AVQuery *query = [self creatQuety];
    query.className  = SECOND_HAND_HOUSE;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            NSArray *dataArray = [self processData:[self randomArray:objects] className:NSStringFromClass([AJSecondHouseCellModel class])];
            
            afterRequest(YES,dataArray);
        }else{
            afterRequest(NO,nil);

        }
      
    }];
}

- (void)fetchLetHouseDataCompleteHander:(RequestBlock)afterRequest{
    AVQuery *query = [self creatQuety];
    query.className  = LET_HOUSE;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (objects.count>0) {
            NSArray *dataArray = [self processData:[self randomArray:objects] className:NSStringFromClass([AJLetHouseCellModel class])];
            
            afterRequest(YES,dataArray);
        }else{
            afterRequest(NO,nil);
            
        }
    }];
}

- (void)fetchNewHouseDataCompleteHander:(RequestBlock)afterRequest{

    AVQuery *query = [self creatQuety];
    query.className  = N_HOUSE;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (objects.count>0) {
            NSArray *dataArray = [self processData:[self randomArray:objects] className:NSStringFromClass([AJNewHouseCellModel class])];
            
            afterRequest(YES,dataArray);
        }else{
            afterRequest(NO,nil);
            
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
- (void)addRecordData:(AVObject *)object recordClassName:(NSString *)recordClassName{
    if (![AVUser currentUser]) {
        return;
    }
    AVObject *houseData = [AJHomeDataCenter creatHouseInfo:object withClassName:recordClassName];
    
    AVQuery *query = [AVQuery queryWithClassName:recordClassName];
    [query whereKey:HOUSE_ID   equalTo:object.objectId];
    [query whereKey:USER_PHONE equalTo:[AVUser currentUser].mobilePhoneNumber];
    //先查询是否已经保存
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            return;
            
        }
        [houseData saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                debugLog(@"浏览记录保存失败");
            }
        }];
    }];
}
+ (AVObject *)creatHouseInfo:(AVObject *)object withClassName:(NSString *)className{
    AVObject *houseData = [[AVObject alloc] initWithClassName:className];
    
    [houseData setObject:object.objectId        forKey:HOUSE_ID];
    [houseData setObject:[AVUser currentUser].mobilePhoneNumber      forKey:USER_PHONE];
    [houseData setObject:object[HOUSE_ESTATE_NAME]          forKey:HOUSE_ESTATE_NAME];
    [houseData setObject:object[HOUSE_THUMB]                forKey:HOUSE_THUMB];

    [houseData setObject:object[HOUSE_AMOUNT]               forKey:HOUSE_AMOUNT];
    [houseData setObject:object[HOUSE_AREAAGE]              forKey:HOUSE_AREAAGE];
    [houseData setObject:object[HOUSE_TAGS]                 forKey:HOUSE_TAGS];
    
    if ([className isEqualToString:LET_RECORD]||[className isEqualToString:LET_FAVORITE]) {
        //租金
        [houseData setObject:object[LET_HOUSE_PRICE]         forKey:LET_HOUSE_PRICE];
        [houseData setObject:object[HOUSE_DIRECTION]         forKey:HOUSE_DIRECTION];
        
    }else if ([className isEqualToString:SECOND_RECORD]||[className isEqualToString:SECOND_FAVORITE]){
        //总价
        [houseData setObject:object[HOUSE_TOTAL_PRICE]       forKey:HOUSE_TOTAL_PRICE];
        //房屋单价
        [houseData setObject:object[HOUSE_UNIT_PRICE]        forKey:HOUSE_UNIT_PRICE];
        
    }else{
        //房屋单价
        [houseData setObject:object[HOUSE_UNIT_PRICE]       forKey:HOUSE_UNIT_PRICE];
        
        //区域
        [houseData setObject:object[HOUSE_AREA]              forKey:HOUSE_AREA];
        
        //地址
        [houseData setObject:object[ESTATE_ADDRESS]        forKey:ESTATE_ADDRESS];
    }
    return houseData;
}

//随机选取5个结果
- (NSArray *)randomArray:(NSArray *)temp
{
    if (temp.count<=SHOW_NUM) {
        return temp;
    }
    //随机数从这里边产生
    NSMutableArray *startArray=[temp mutableCopy];
    //随机数产生结果
    NSMutableArray *resultArray=[NSMutableArray new];
    //随机数个数
    for (int i=0; i<SHOW_NUM; i++) {
        int t = arc4random()%startArray.count;
        resultArray[i] = startArray[t];
        startArray[t] = [startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return resultArray;
}

#pragma mark -geter and setter
- (AVQuery *)creatQuety{
    AVQuery *query = [[AVQuery alloc] init];
    query.limit = MAX_NUM;
    query.skip = 0;
    query.cachePolicy = kAVCachePolicyIgnoreCache;
    [query orderByDescending:@"createdAt"];
    
    return query;
}
@end
