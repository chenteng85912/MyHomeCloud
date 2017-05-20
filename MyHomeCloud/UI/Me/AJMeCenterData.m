//
//  TJMeCenterData.m
//  webhall
//
//  Created by TJ-iOS on 2017/2/22.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "AJMeCenterData.h"
#import "AJMeModel.h"
#import "AJMyhouseViewController.h"
#import "AJSettingViewController.h"
#import "AJOtherViewController.h"

@implementation AJMeCenterData

+ (NSMutableArray *)userCenterData
{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableArray <AJMeModel *>*temp = [NSMutableArray array];
    
    //section0
    AJMeModel *model = [AJMeModel new];
    model.title = @"我的房源";
    model.iconName = @"house";
    model.className = NSStringFromClass([AJMyhouseViewController class]);
    [temp addObject:model];
    
    model = [AJMeModel new];
    model.title = @"我的收藏";
    model.iconName = @"liked";
    model.className = NSStringFromClass([AJMyhouseViewController class]);
    [temp addObject:model];
    
    model = [AJMeModel new];
    model.title = @"浏览记录";
    model.iconName = @"record";
    model.className = NSStringFromClass([AJMyhouseViewController class]);
    [temp addObject:model];
    
    //管理员
    if ([[AVUser currentUser][USER_ROLE] integerValue]==1) {
        model = [AJMeModel new];
        model.title = @"所有房源";
        model.iconName = @"allHouse";
        model.className = NSStringFromClass([AJMyhouseViewController class]);
        [temp addObject:model];
        
    }
    [dataArray addObject:temp];
    
    //section1
    temp = [NSMutableArray array];
//    model = [AJMeModel new];
//    model.title = @"购房计算器";
//    model.iconName = @"house_cal";
//    model.className = NSStringFromClass([AJSearchViewController class]);
//    [temp addObject:model];
    
    model = [AJMeModel new];
    model.title = @"客服热线";
    model.iconName = @"service_phone";
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
