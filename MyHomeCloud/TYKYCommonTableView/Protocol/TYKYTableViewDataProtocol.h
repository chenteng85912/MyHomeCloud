//
//  TYKYTableViewDataProtocol.h
//  MVPProject
//
//  Created by Apple on 2017/1/23.
//  Copyright © 2017年 Yin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYKYTableViewDataProtocol <NSObject>

@optional

//发送普通post请求
- (void)fetchDataWithUrlStr:(NSString *)urlString
             bodyParameters:(NSMutableDictionary *)params
                   complete:(void(^)(NSError *error, id objectDic))afterRequest;

//根据保存字段 读取本地数据
- (NSArray *)readLocalData:(NSString *)localDataKey;

//根据保存字段 保存本地数据
- (void)saveLocalData:(NSMutableArray *)dataArray forKey:(NSString *)localDataKey;

//时效检测
- (BOOL)checkLocalData:(NSString *)localKey;
@end
