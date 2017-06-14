//
//  TJMeCenterData.m
//  webhall
//
//  Created by TJ-iOS on 2017/2/22.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "AJMeCenterData.h"
#import "AJMeModel.h"
#import "AJSettingViewController.h"
#import "AJOtherViewController.h"
#import "AJUserHouseViewController.h"

NSString *const ServicePhone = @"4006005555";

@implementation AJMeCenterData

+ (NSMutableArray *)userCenterData
{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableArray <AJMeModel *>*temp = [NSMutableArray array];
    
    //section0
    AJMeModel *model = [AJMeModel new];
    model.title = @"我的房源";
    model.iconName = @"house";
    model.showModal = MyHouseModal;
    model.isNeedLogin = YES;
    model.className = NSStringFromClass([AJUserHouseViewController class]);
    [temp addObject:model];
    
    model = [AJMeModel new];
    model.title = @"我的关注";
    model.showModal = UserFavoriteModal;
    model.iconName = @"favorite";
    model.isNeedLogin = YES;
    model.className = NSStringFromClass([AJUserHouseViewController class]);
    [temp addObject:model];
    
    model = [AJMeModel new];
    model.title = @"浏览记录";
    model.iconName = @"record";
    model.isNeedLogin = YES;
    model.showModal = UserRecordModal;
    model.className = NSStringFromClass([AJUserHouseViewController class]);
    [temp addObject:model];
    
    model = [AJMeModel new];
    model.title = @"我的预约";
    model.iconName = @"reserver";
    model.isNeedLogin = YES;
    model.className = NSStringFromClass([AJOtherViewController class]);
    [temp addObject:model];
    
    [dataArray addObject:temp];
    
    //section1
    temp = [NSMutableArray array];
//    model = [AJMeModel new];
//    model.title = @"购房计算器";
//    model.iconName = @"house_cal";
//    model.className = NSStringFromClass([AJSearchViewController class]);
//    [temp addObject:model];
    
    model = [AJMeModel new];
    model.title = [NSString stringWithFormat:@"客服热线(%@)",ServicePhone];
    model.iconName = @"service_phone";
    model.phoneNumber = ServicePhone;
    [temp addObject:model];
    [dataArray addObject:temp];


    //section2
    temp = [NSMutableArray array];
    model = [AJMeModel new];
    model.title = @"设置";
    model.iconName = @"setting";
    model.className = NSStringFromClass([AJSettingViewController class]);
    [temp addObject:model];
    
    [dataArray addObject:temp];
    
    return dataArray;
}

+ (NSMutableArray *)getSettingData{
    NSMutableArray *temp = [NSMutableArray array];
    
    AJMeModel *model = [AJMeModel new];
    model.title = @"关于我们";
    model.className = NSStringFromClass([AJOtherViewController class]);
    [temp addObject:model];
    
    model = [AJMeModel new];
    model.title = @"隐私说明";
    model.className = NSStringFromClass([AJOtherViewController class]);
    [temp addObject:model];
    
    model = [AJMeModel new];
    model.title = @"清理缓存";
    [temp addObject:model];
    
    return temp;
}
@end
