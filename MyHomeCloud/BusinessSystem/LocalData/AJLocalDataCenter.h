//
//  TYKYLocalDataCenter.h
//  webhall
//
//  Created by tjsoft on 2017/4/6.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SearchModal) {
    SHouseModal,    //二手房
    LHouseModal,       //租房
    NHouseModal,         //新房

};

extern NSString *const TIME_KEY;
@interface AJLocalDataCenter : NSObject

//图片存储地址
+ (NSString *)imagePathWithImageName:(NSString *)imageName;

//文件存储地址
+ (NSString *)filePathWithURLstring:(NSString *)fileUrl;

//检测本地数据时效性
+ (BOOL)checkLocalData:(NSString *)localKey;

//保存加载本地数据时间
+ (void)saveLocalDataTime:(NSString *)localKey;

//删除加班本地数据时间
+ (void)removeLocalDataTime:(NSString *)localKey;

//计算缓存大小
+ (NSString *)calcuteLocalDataSize;

//清理缓存
+ (void)clearLocalData;

//读取搜索关键词
+ (NSMutableArray *)readLocalSearchData:(SearchModal)searchModal;

//保存搜索关键词
+ (void)saveLocalSearchKey:(NSMutableArray *)searchArray searchModal:(SearchModal)searchModal;

//清空搜索关键词
+ (void)clearLocalSearchKeys:(SearchModal)searchModal;

//删除某条搜索关键词
+ (void)deleteSearchKey:(NSMutableArray *)searchArray searchModal:(SearchModal)searchModal;

@end
