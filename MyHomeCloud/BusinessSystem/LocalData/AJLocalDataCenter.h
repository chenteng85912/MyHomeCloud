//
//  TYKYLocalDataCenter.h
//  webhall
//
//  Created by tjsoft on 2017/4/6.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SearchModal) {
    SHouseModal,     //二手房
    LHouseModal,     //租房
    NHouseModal,     //新房

};

extern NSString *const TIME_KEY;
@interface AJLocalDataCenter : NSObject

//图片存储地址
+ (NSString *)imagePathWithImageName:(NSString *)imageName;

//文件存储地址
+ (NSString *)filePathWithURLstring:(NSString *)fileUrl;

//保存本地房屋数据
+ (void)saveLocalHouseInfo:(NSArray *)houseInfo withHouseId:(NSString *)houseId;

//读取本地房屋数据
+ (NSMutableArray *)readLocalHouseInfo:(NSString *)houseId;

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
