//
//  AJMessageBeanDao.m
//  TYKYTwoLearnOneDo
//
//  Created by tjsoft on 16/5/12.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import "AJMessageBeanDao.h"
#import "AJMessageBean.h"

NSString *const USER_ID = @"USER_ID";           //用户ID
NSString *const MSG_TITLE = @"MSG_TITLE";       //消息标题
NSString *const MSG_CONTENT = @"MSG_CONTENT";   //消息内容
NSString *const MSG_TYPE = @"MSG_TYPE";         //消息类型
NSString *const MSG_TIME = @"MSG_TIME";         //消息时间
NSString *const MSG_URL = @"MSG_URL";           //消息链接
NSString *const IS_READ = @"IS_READ";           //是否已读

NSString *const NOTICE_LIST = @"NOTICE_LIST";       //消息列表-表格
NSString *const NOTICE_DETAILS = @"NOTICE_DETAILS"; //消息详情列表-表格

@implementation AJMessageBeanDao

#pragma mark 创建表格
+ (void)createTable
{
    [[AJDataBaseDao shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            BOOL result = false;
            
            //消息类型表
            NSString *msgListStr = [NSString stringWithFormat:@"CREATE TABLE if not exists %@(_id INTEGER PRIMARY KEY AUTOINCREMENT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER);",NOTICE_LIST,USER_ID,MSG_TITLE,MSG_CONTENT,MSG_TYPE,MSG_TIME,MSG_URL,IS_READ];
            
            result = [db executeUpdate:msgListStr];
            if (result) {
                debugLog(@"消息类型表---创建成功");
            }else{
                debugLog(@"消息类型表---创建失败");
            }

            //消息详情表
             NSString *msgDetailsStr = [NSString stringWithFormat:@"CREATE TABLE if not exists %@(_id INTEGER PRIMARY KEY AUTOINCREMENT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER);",NOTICE_DETAILS,USER_ID,MSG_TITLE,MSG_CONTENT,MSG_TYPE,MSG_TIME,MSG_URL,IS_READ];
            result = [db executeUpdate:msgDetailsStr];
            if (result) {
                debugLog(@"消息详情表---创建成功");
            }else{
                debugLog(@"消息详情表---创建失败");
            }
        }
        
    }];

}
#pragma mark 查询类型消息
+ (BOOL)checkListMsgBean:(AJMessageBean *)message{
    __block BOOL res = NO;
    [[AJDataBaseDao shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
       
        //先查询
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' AND %@ = '%@'",NOTICE_LIST,USER_ID,message.userId,MSG_TYPE,message.msgType];
        FMResultSet *resultSet = [db executeQuery:sql];
        
        // 2.遍历结果
        if ([resultSet next]) {
        
            debugLog(@"存在%@类型的消息",message.msgType);
            res = YES;
        }
        
    }];
    return res;
}
#pragma mark 插入消息
+ (BOOL)insertMsgBean:(AJMessageBean *)message formType:(MessageFormType)type{
   
    __block BOOL res = NO;
    [[AJDataBaseDao shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        if (type==DetailsMessageType) {
            res = [db executeUpdate:[self sqlStrMessage:message FormName:NOTICE_DETAILS]];

        }else{
            
          res = [db executeUpdate:[self sqlStrMessage:message FormName:NOTICE_LIST]];
            
        }
        
    }];
    if (res) {
        debugLog(@"类型为%@的消息插入成功",message.msgType);
    }else{
        debugLog(@"类型为%@的消息插入失败",message.msgType);
    }

    return res;
}
+ (NSString *)sqlStrMessage:(AJMessageBean *)message FormName:(NSString *)formName{
    
    NSString *str = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@,%@, %@, %@ )",formName,USER_ID,MSG_TITLE,MSG_CONTENT,MSG_TYPE,MSG_TIME,MSG_URL,IS_READ];
    
   NSString *sql = [str stringByAppendingFormat:@"VALUES ( '%@', '%@', '%@','%@', '%@',' %@' ,'%d');", message.userId,message.msgTitle,message.msgContent,message.msgType,message.msgTime,message.msgUrl,message.isRead];
    
    return sql;
}

#pragma mark 删除消息
+ (BOOL)deleteOneNotice:(AJMessageBean *)message formType:(MessageFormType)type{
   
    //2.获得数据库
    __block BOOL res = NO;
    [[AJDataBaseDao shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql;
        if (type==ListMessageType) {
            sql=  [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'  AND %@ = '%@' ",NOTICE_LIST,USER_ID,message.userId,MSG_TYPE,message.msgType];
        }else{
            sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'  AND %@ = '%@' AND %@ = '%@' ",NOTICE_DETAILS,USER_ID,message.userId,MSG_TYPE,message.msgType,MSG_TIME,message.msgTime];
        }
        res = [db executeUpdate:sql];
        if (res) {
            debugLog(@"类型为%@的消息删除成功",message.msgType);
        }else{
            debugLog(@"类型为%@的消息删除失败",message.msgType);
        }
    }];
    return res;
}

#pragma mark 删除某类型所有消息
+ (BOOL)deleteMessagesWithMsgType:(AJMessageBean *)message{
    
    //2.获得数据库
    __block BOOL res = NO;
    [[AJDataBaseDao shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql=  [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'  AND %@ = '%@' ",NOTICE_DETAILS,USER_ID,message.userId,MSG_TYPE,message.msgType];
        res = [db executeUpdate:sql];
        if (res) {
            debugLog(@"类型为%@的消息清空成功",message.msgType);
        }else{
            debugLog(@"类型为%@的消息清空失败",message.msgType);
        }
    }];
    return res;
}

#pragma mark 更新消息状态
+ (BOOL)updateMessage:(AJMessageBean *)message{
    __block BOOL res = NO;
    [[AJDataBaseDao shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        
        //更新某条消息的已读状态
        NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = '%d' where %@ = '%@' and %@ = '%@' and %@ = '%@'",NOTICE_DETAILS,IS_READ,message.isRead,USER_ID,message.userId,MSG_TYPE,message.msgType,MSG_TIME,message.msgTime];
        
        res = [db executeUpdate:sql];
        if (res) {
            debugLog(@"类型为%@的消息更新已读状态成功",message.msgType);
        }else{
            debugLog(@"类型为%@的消息更新已读状态失败",message.msgType);
        }
    }];
    return res;
}

#pragma mark 查找指定类型的所有消息
+ (NSArray *)findMessages:(AJMessageBean *)message pageNo:(int)pageNo pageSize:(int)pageSize
{
    __block NSMutableArray * datas = [[NSMutableArray alloc] init];
    [[AJDataBaseDao shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        // 1.执行查询语句
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' AND %@ = '%@'order by _id desc limit %d offset %d ",NOTICE_DETAILS ,USER_ID,message.userId,MSG_TYPE,message.msgType,pageSize, pageNo * pageSize];
        FMResultSet *resultSet = [db executeQuery:sql];
        
        // 2.遍历结果
        while ([resultSet next]) {
            [datas addObject:[self messageBeanByFMResultSet:resultSet]];
        }
    }];
    return datas;
}
#pragma mark 查找用户的所有消息
+ (NSArray *)findListMessagesWithUserId:(NSString *)userId

{
    __block NSMutableArray * datas = [[NSMutableArray alloc] init];
    [[AJDataBaseDao shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        // 1.执行查询语句
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' ",NOTICE_LIST ,USER_ID,userId];
        FMResultSet *resultSet = [db executeQuery:sql];
        
        // 2.遍历结果
        while ([resultSet next]) {
            [datas addObject:[self messageBeanByFMResultSet:resultSet]];
        }
    }];
    return datas;
}
+ (AJMessageBean *)messageBeanByFMResultSet:(FMResultSet *)resultSet
{
    AJMessageBean * messageBean = [[AJMessageBean alloc] init];
    
    messageBean._id = [resultSet longForColumn:@"_id"];
    
    messageBean.userId = [resultSet stringForColumn:USER_ID];
    messageBean.msgType = [resultSet stringForColumn:MSG_TYPE];
    messageBean.msgContent = [resultSet stringForColumn:MSG_CONTENT];
    messageBean.msgTitle = [resultSet stringForColumn:MSG_TITLE];
    messageBean.msgTime = [resultSet stringForColumn:MSG_TIME];
    messageBean.msgUrl = [resultSet stringForColumn:MSG_URL];
    messageBean.isRead = [resultSet boolForColumn:IS_READ];

    return messageBean;
}

@end
