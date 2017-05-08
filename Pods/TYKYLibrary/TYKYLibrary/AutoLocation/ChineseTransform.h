//
//  ChininesTransform.h
//
//  Created by Apple on 16/7/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseTransform : NSObject

//读取本地数据
+(NSMutableArray *)initCityDataFromLocal;

//中文转拼音
+ (NSString *)chineseTransToPinyin:(NSString *)chinese;

//拼音数组按首字母排序
+(NSArray *)arrangeWithPINYIN:(NSArray *)pinyinArray;

//生成最后结果
+ (NSMutableDictionary *)makeResultCityDictionary:(NSArray *)pinyinArray;

//中文判断
+(BOOL)isChinese:(NSString *)str;

@end
