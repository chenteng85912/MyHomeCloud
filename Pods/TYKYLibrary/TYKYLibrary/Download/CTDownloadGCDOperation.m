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

//待上传队列
@property (strong, nonatomic) NSMutableDictionary <NSString *,CTDownloadWithSession*> *prepareDownloadArray;
//正在上传的队列
@property (strong, nonatomic) NSMutableDictionary <NSString *,CTDownloadWithSession *> *downloadingArray;

@end

@implementation CTDownloadGCDOperation

//使用dispatch_once改进单例模式
+ (CTDownloadGCDOperation *) Instance{
    static CTDownloadGCDOperation *downLoadGCD = nil;

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
+ (NSMutableDictionary <NSString *,CTDownloadWithSession*> *)prepareDownloadArray{
    return [self Instance].prepareDownloadArray;
}
+ (NSMutableDictionary <NSString *,CTDownloadWithSession*> *)downloadingArray{
    return [self Instance].downloadingArray;
}
//开始分配上传任务
+ (void)startDownload{
    
    if ([self Instance].prepareDownloadArray.count==0) {
        return;
    }
    
    NSInteger totalNum = [self Instance].prepareDownloadArray.count + [self Instance].downloadingArray.count;

    if (totalNum<maxDownloadingNum) {
        [self addNewDownloadingQueue:totalNum];

    }else{
        [self addNewDownloadingQueue:maxDownloadingNum];

    }

}
//添加新的上传任务
+ (void)addNewDownloadingQueue:(NSInteger)startNum{

    [[self Instance].prepareDownloadArray enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, CTDownloadWithSession * _Nonnull obj, BOOL * _Nonnull stop) {
        
        [[self Instance].downloadingArray setObject:obj forKey:obj.urlStr];
        [[self Instance].prepareDownloadArray removeObjectForKey:key];
        
        if ([self Instance].downloadingArray.count==startNum) {
            [self addDownloadingQueue];
            *stop = YES;
        }
       
    }];
    
}
//添加下载任务
+ (void)addDownloadingQueue{
    
    for (CTDownloadWithSession  *upload in [self Instance].downloadingArray.allValues) {
        if (upload.downloadState==WaitingDownloadState) {
            
            void (^task)(void) = ^{
                [upload startDownload];
                
            };
            dispatch_async([self Instance].uploadQueue, task);
            
        }
    }
}
//清空所有下载队列
+ (void)clearAllDownloadQueue{
    
    for (CTDownloadWithSession *upload in [self Instance].downloadingArray.allValues) {
        if (upload.downloadState==DownloadingState) {
            [upload cancelDownload];

        }
    }
    [[self Instance].downloadingArray removeAllObjects];
    [[self Instance].prepareDownloadArray removeAllObjects];
}

//下载失败的 重新下载
+ (void)downLoadAgain:(NSString *)fileUrl{
    [[self Instance].downloadingArray enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CTDownloadWithSession * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.downloadState==DownloadFailState&&[obj.urlStr isEqualToString:fileUrl]) {
            void (^task)(void) = ^{
                [obj startDownload];
                
            };
            dispatch_async([self Instance].uploadQueue, task);
        }
    }];
}
//下载成功后 移除某个下载队列
+ (void)removeDownloadTool:(NSString *)fileUrl{
    if (!fileUrl) {
        return;
    }
    
    [[self Instance].uploadLock lock];
    
    [[self Instance].downloadingArray removeObjectForKey:fileUrl];
   
    [self  startDownload];
    
    [[self Instance].uploadLock unlock];
}

@end
