//
//  TYKYUploadGCDOperation.h
//  webhall
//
//  Created by tjsoft on 2017/3/25.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GCDOpereaton [CTDownloadGCDOperation Instance]

@class CTDownloadWithSession;
@interface CTDownloadGCDOperation : NSObject

//待上传队列
@property (strong, nonatomic) NSMutableDictionary <NSString *,CTDownloadWithSession*> *prepareDownloadArray;
//正在上传的队列
@property (strong, nonatomic) NSMutableDictionary <NSString *,CTDownloadWithSession *> *downloadingArray;

+ (CTDownloadGCDOperation *) Instance;

//开始分配上传任务
- (void)startDownload;

//上传成功后 移除上传队列
- (void)removeDownloadTool:(NSString *)fileUrl;

//清空上传队列
- (void)clearAllDownloadQueue;

//下载失败的 重新下载
- (void)downLoadAgain:(NSString *)fileUrl;

@end
