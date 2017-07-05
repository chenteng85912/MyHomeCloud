//
//  TJDataBaseDao.m
//  TYKYTwoLearnOneDo
//
//  Created by tjsoft on 16/5/12.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import "AJDataBaseDao.h"

NSString *const DATABASEFILEPATH  = @"ShenZhenWall.sqlite";

@implementation AJDataBaseDao

static FMDatabaseQueue *queue = nil;
char *errorMsg = NULL;

/**
 * 关闭数据库
 */
+ (void)closeDataBase
{
    //关闭
    [queue close];
    queue = nil;
}

/**
 * 创建数据库
 */
+ (void)openDataBase
{
    [[self shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        
        //3.打开数据库
        if ([db open]) {
            //BOOL result = false;
        }
        
    }];
}
/**
 * 创建FMDatabaseQueue单例
 */
+ (FMDatabaseQueue *)shareDatabaseQueue
{
    if (!queue) {
        //创建文件夹 获得数据库文件的路径
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *fullFilePath=[docPath stringByAppendingPathComponent:DATABASEFILEPATH];
        queue = [FMDatabaseQueue databaseQueueWithPath:fullFilePath];
    }
    
    return queue;
}


@end
