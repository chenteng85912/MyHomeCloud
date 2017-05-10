//
//  TJMeCenterData.h
//  webhall
//
//  Created by TJ-iOS on 2017/2/22.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJMeCenterData : NSObject

//获取我的列表数据
+ (NSMutableArray *)userCenterData;

//设置界面数据
+ (NSMutableArray *)getSettingData;

@end
