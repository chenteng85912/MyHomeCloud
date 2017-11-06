//
//  TJVersionAutoUpdate.h
//  TAIJIToolsFramework
//
//  Created by 腾 on 16/11/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,OpenStoreStyle) {
    OpenAppStoreOutApp,  //应用外部打开苹果商店
    OpenAppStoreInApp    //应用内部打开苹果商店
};

@interface CTVersionAutoUpdate : NSObject
/**
 *  版本更新 传入应用ID 选择应用商店跳转方式
 */
+ (void)checkAppStoreVersion:(NSString *)appId openStoreStyle:(OpenStoreStyle)showStyle;

@end
