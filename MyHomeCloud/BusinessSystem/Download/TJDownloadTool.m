//
//  TJDownloadModal.m
//  zhumadianparent
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import "TJDownloadTool.h"


@interface TJDownloadTool ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSData *partialData;//暂停数据
@property (nonatomic, strong) NSURLSession *session;//下载任务
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSURL *downloadURl;//下载地址
@property (nonatomic, assign) BOOL isUploading;
@end

@implementation TJDownloadTool
{
    long long contentLenght;
}

- (instancetype)initWithDownloadUrlStr:(NSString *)urlStr{
    self = [super init];
    if (self) {
        self.downloadURl = [NSURL URLWithString:urlStr];
    }
    return self;
}
- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    }
    return _session;
    
}

-(void)startDownload
{
    //创建网络任务
    self.task = [self.session downloadTaskWithURL:self.downloadURl];
    [self.task resume];
    [self fetchFilePathExtension];
    NSLog(@"start download task");
    
}

-(void)pauseDownload
{
    NSLog(@"Pause download task");
    if (self.task) {
        //取消下载任务，把已下载数据存起来
        __weak typeof(self) vc = self;
        [self.task cancelByProducingResumeData:^(NSData *resumeData) {
            
            if (resumeData) {
                vc.partialData = resumeData;
            }
            vc.task = nil;
            
        }];
    }
}

-(void)resumeDownload
{
    NSLog(@"resume download task");
    //判断是否又已下载数据，有的话就断点续传，没有就完全重新下载
    if (self.partialData) {
        self.task = [self.session downloadTaskWithResumeData:self.partialData];
        
    }else{
        self.task = [self.session downloadTaskWithURL:self.downloadURl];
        
    }
    [self.task resume];
}
- (void)cancelDownload{
    if (self.task) {
        [self.task cancel];
    }
    self.task = nil;
}
#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    
    NSString *createPath = [AJLocalDataCenter filePathWithURLstring:self.downloadURl.absoluteString];
    NSString *fileExten = [self fetchFilePathExtension];
    if (!fileExten) {
        return;

    }
    
    createPath = [NSString stringWithFormat:@"%@.%@",createPath,fileExten];
    
    // 将临时文件剪切或者复制Caches文件夹
    BOOL success = [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:createPath error:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(downLoadedSuccessOrFail:)]) {
            if (success) {
                self.state = @2;
                [self.delegate downLoadedSuccessOrFail:YES];
            }else{
                self.state = @0;
                [self.delegate downLoadedSuccessOrFail:NO];

            }
       
        }
    });
    
    self.task = nil;
    
}

/**
 bytesWritten               : 本次下载的字节数
 totalBytesWritten          : 已经下载的字节数
 totalBytesExpectedToWrite  : 下载总大小
 */
/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    debugLog(@"downloading...");
    //更新数据库 一次
    contentLenght = totalBytesExpectedToWrite;

    if (!_isUploading) {
        _isUploading = YES;
        self.state = @1;
     
    }
    float currentProgress = totalBytesWritten/(double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(changeProgressValue:)]) {
            [self.delegate changeProgressValue:currentProgress];
        }

    });
}
/** 续传的代理方法 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    debugLog(@"续传");
}
// 由于下载失败导致的下载中断会进入此协议方法,也可以得到用来恢复的数据
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        // 保存恢复数据
        self.partialData = error.userInfo[NSURLSessionDownloadTaskResumeData];
        debugLog(@"error:%@",error.userInfo);
        self.state = @0;
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(downLoadedSuccessOrFail:)]) {
                [self.delegate downLoadedSuccessOrFail:NO];

            }
        });

    }
    
}
- (NSString *)makeSizeString:(float)filesize{
    NSString *fileSizeString = @"";
    
    if(filesize/1024>=1024)
    {
        filesize = filesize/1024/1024;
        fileSizeString = [NSString stringWithFormat:@"%.1f M",filesize];
    }
    else
    {
        fileSizeString = [NSString stringWithFormat:@"%d K",(int)filesize/1024];
    }
    return fileSizeString;
}

//保存文件后缀名
- (NSString *)fetchFilePathExtension{
    
    NSString *createPath = [AJLocalDataCenter filePathWithURLstring:self.downloadURl.absoluteString];
    NSString *fileExten = [MyUserDefaults objectForKey:createPath];
    if (fileExten) {
        return fileExten;
    }
    //创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:self.downloadURl];
    NSURLResponse *response;
    //发送同步请求获取响应类型
    [NSURLConnection sendSynchronousRequest:request returningResponse:(&response) error:nil];
    
    debugLog(@"%@",response.suggestedFilename);
    
    if (response.suggestedFilename.pathExtension) {
        [MyUserDefaults setObject:response.suggestedFilename.pathExtension forKey:createPath];

        return response.suggestedFilename.pathExtension;
    }
    return nil;

}
@end
