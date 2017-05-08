//
//  TYKYLocalDataCenter.h
//  webhall
//
//  Created by tjsoft on 2017/4/6.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYKYLocalDataCenter : NSObject

//图片存储地址
+ (NSString *)imagePathWithImageName:(NSString *)imageName;

//文件存储地址
+ (NSString *)filePathWithURLstring:(NSString *)fileUrl;

//读取本地数据
+ (id)readLocalData:(NSString *)localDataKey;

//保存本地数据
+ (BOOL)saveLocalData:(id)localData forKey:(NSString *)localDataKey;

//检测本地数据时效性
+ (BOOL)checkLocalData:(NSString *)localKey;

//计算缓存大小
+ (NSString *)calcuteLocalDataSize;

//清理缓存
+ (void)clearLocalData;

@end
