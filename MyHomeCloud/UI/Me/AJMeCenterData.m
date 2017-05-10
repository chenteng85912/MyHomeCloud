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

@implementation AJMeCenterData

+ (NSMutableArray *)userCenterData
{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableArray <AJMeModel *>*temp = [NSMutableArray array];
    
    //section0
    AJMeModel *model = [AJMeModel new];
    model.title = @"二手房关注";
    model.iconName = @"house";
    model.className = NSStringFromClass([AJMyhouseViewController class]);
    model.checkLogin = YES;
    [temp addObject:model];
    
    model = [AJMeModel new];
    model.title = @"小区关注";
    model.iconName = @"estate";
    model.className = NSStringFromClass([AJMyhouseViewController class]);
    model.checkLogin = YES;
    [temp addObject:model];
    
    model = [AJMeModel new];
    model.title = @"浏览记录";
    model.iconName = @"record";
    model.className = NSStringFromClass([AJMyhouseViewController class]);
    model.checkLogin = YES;
    [temp addObject:model];
    
    [dataArray addObject:temp];
    
    //section1
    temp = [NSMutableArray array];
    model = [AJMeModel new];
    model.title = @"购房计算器";
    model.iconName = @"house_cal";
    model.className = NSStringFromClass([AJMyhouseViewController class]);
    model.checkLogin = YES;
    [temp addObject:model];
    
    model = [AJMeModel new];
    model.title = @"客服热线";
    model.iconName = @"service_phone";
    model.className = NSStringFromClass([AJMyhouseViewController class]);
    model.checkLogin = YES;
    [temp addObject:model];
    [dataArray addObject:temp];


    //section2
    temp = [NSMutableArray array];
    model = [AJMeModel new];
    model.title = @"设置";
    model.iconName = @"setting";
    model.className = NSStringFromClass([AJMyhouseViewController class]);
    model.checkLogin = YES;
    [temp addObject:model];
    
    [dataArray addObject:temp];
    
    return dataArray;
}

+ (NSMutableArray *)getSettingData{
    NSMutableArray *temp = [NSMutableArray array];
   
    
    return temp;
}
@end
