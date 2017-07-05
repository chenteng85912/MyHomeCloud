//
//  TJMessageBeanDao.h
//  TYKYTwoLearnOneDo
//
//  Created by tjsoft on 16/5/12.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJDataBaseDao.h"
#import "AJMessageBean.h"

typedef NS_ENUM(NSInteger,MessageFormType) {
    ListMessageType,      //消息列表
    DetailsMessageType    //消息详情列表

};

@interface AJMessageBeanDao : AJDataBaseDao

#pragma mark 创建表格
+ (void)createTable;

#pragma mark 查询类型消息
+ (BOOL)checkListMsgBean:(AJMessageBean *)message;

#pragma mark 插入消息
+ (BOOL)insertMsgBean:(AJMessageBean *)message formType:(MessageFormType)type;

#pragma mark 删除消息
+ (BOOL)deleteOneNotice:(AJMessageBean *)message formType:(MessageFormType)type;

#pragma mark 删除某类型所有消息
+ (BOOL)deleteMessagesWithMsgType:(AJMessageBean *)message;

#pragma mark 更新消息状态
+ (BOOL)updateMessage:(AJMessageBean *)message;

#pragma mark 查找指定类型消息所有数据
+ (NSArray *)findMessages:(AJMessageBean *)message pageNo:(int)pageNo pageSize:(int)pageSize;

#pragma mark 查找用户的所有消息
+ (NSArray *)findListMessagesWithUserId:(NSString *)userId;

@end
