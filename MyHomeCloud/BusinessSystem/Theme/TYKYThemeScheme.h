//
//  TYKYThemeScheme.h
//  webhall
//
//  Created by tjsoft on 2017/4/25.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const ThemeUpdateNotification;

@interface TYKYThemeScheme : NSObject

//颜色数组
+ (NSArray *)colorArray;

//颜色字典
+ (NSDictionary *)colorDic;

//当前颜色KEY
+ (NSString *)currentColorKey;

//当前颜色值
+ (NSString *)currentColorStr;

//保存颜色KEY
+ (void)saveCurrentThemeColor:(NSString *)key;

//换肤通知
+ (void)postChangeThemeNotification;


@end
