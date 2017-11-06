//
//  TYKYUploadGCDOperation.h
//  webhall
//
//  Created by tjsoft on 2017/3/25.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTDownloadWithSession;
@interface CTDownloadGCDOperation : NSObject

+ (NSMutableDictionary <NSString *,CTDownloadWithSession*> *)prepareDownloadArray;

+ (NSMutableDictionary <NSString *,CTDownloadWithSession*> *)downloadingArray;

//开始分配上传任务
+ (void)startDownload;

//上传成功后 移除上传队列
+ (void)removeDownloadTool:(NSString *)fileUrl;

//清空上传队列
+ (void)clearAllDownloadQueue;

//下载失败的 重新下载
+ (void)downLoadAgain:(NSString *)fileUrl;

@end
