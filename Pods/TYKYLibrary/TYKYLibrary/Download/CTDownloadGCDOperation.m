//
//  TYKYdownLoadGCDOperation.m
//  webhall
//
//  Created by tjsoft on 2017/3/25.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "CTDownloadGCDOperation.h"
#import "CTDownloadWithSession.h"

//最大队列数量
NSInteger const maxDownloadingNum = 99;

@interface CTDownloadGCDOperation ()

@property (strong, nonatomic) dispatch_queue_t uploadQueue;

@property (strong, nonatomic) NSLock *uploadLock;//同步锁

@end

static CTDownloadGCDOperation *downLoadGCD = nil;

@implementation CTDownloadGCDOperation

//使用dispatch_once改进单例模式
+ (CTDownloadGCDOperation *) Instance{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        downLoadGCD = [self new];
        // 创建并发队列
        downLoadGCD.uploadQueue =  dispatch_queue_create("TengDownloadGCDOperation", DISPATCH_QUEUE_CONCURRENT);
        downLoadGCD.prepareDownloadArray = [NSMutableDictionary new];
        downLoadGCD.downloadingArray = [NSMutableDictionary new];
        downLoadGCD.uploadLock = [NSLock new];
    });
    return downLoadGCD;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downLoadGCD = [super allocWithZone:zone];
    });
    return downLoadGCD;
}

- (id)copyWithZone:(NSZone *)zone
{
    return downLoadGCD;
}
//开始分配上传任务
- (void)startDownload{
    
    if (downLoadGCD.prepareDownloadArray.count==0) {
        return;
    }
    
    NSInteger totalNum = downLoadGCD.prepareDownloadArray.count + downLoadGCD.downloadingArray.count;

    if (totalNum<maxDownloadingNum) {
        [downLoadGCD addNewDownloadingQueue:totalNum];

    }else{
        [downLoadGCD addNewDownloadingQueue:maxDownloadingNum];

    }

}
//添加新的上传任务
- (void)addNewDownloadingQueue:(NSInteger)startNum{

    [downLoadGCD.prepareDownloadArray enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, CTDownloadWithSession * _Nonnull obj, BOOL * _Nonnull stop) {
        
        [downLoadGCD.downloadingArray setObject:obj forKey:obj.urlStr];
        [downLoadGCD.prepareDownloadArray removeObjectForKey:key];
        
        if (downLoadGCD.downloadingArray.count==startNum) {
            [downLoadGCD addDownloadingQueue];
            *stop = YES;
        }
       
    }];
    
}
//添加下载任务
- (void)addDownloadingQueue{
    
    for (CTDownloadWithSession  *upload in downLoadGCD.downloadingArray.allValues) {
        if (upload.downloadState==WaitingDownloadState) {
            
            void (^task)() = ^{
                [upload startDownload];
                
            };
            dispatch_async(downLoadGCD.uploadQueue, task);
            
        }
    }
}
//清空所有下载队列
- (void)clearAllDownloadQueue{
    
    for (CTDownloadWithSession *upload in downLoadGCD.downloadingArray.allValues) {
        if (upload.downloadState==DownloadingState) {
            [upload cancelDownload];

        }
    }
    [downLoadGCD.downloadingArray removeAllObjects];
    [downLoadGCD.prepareDownloadArray removeAllObjects];
}

//下载失败的 重新下载
- (void)downLoadAgain:(NSString *)fileUrl{
    [downLoadGCD.downloadingArray enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CTDownloadWithSession * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.downloadState==DownloadFailState&&[obj.urlStr isEqualToString:fileUrl]) {
            void (^task)() = ^{
                [obj startDownload];
                
            };
            dispatch_async(downLoadGCD.uploadQueue, task);
        }
    }];
}
//下载成功后 移除某个下载队列
- (void)removeDownloadTool:(NSString *)fileUrl{
    if (!fileUrl) {
        return;
    }
    
    [downLoadGCD.uploadLock lock];
    
    [downLoadGCD.downloadingArray removeObjectForKey:fileUrl];
   
    [downLoadGCD startDownload];
    
    [downLoadGCD.uploadLock unlock];
}

@end
