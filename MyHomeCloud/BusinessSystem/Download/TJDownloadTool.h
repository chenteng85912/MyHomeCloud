//
//  TJDownloadModal.h
//  zhumadianparent
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TJDownloadToolDelegate <NSObject>

- (void)changeProgressValue:(float)progress;

- (void)downLoadedSuccessOrFail:(BOOL)state;

@end
@interface TJDownloadTool : NSObject

@property (nonatomic,weak) id<TJDownloadToolDelegate>delegate;
@property (nonatomic,strong) NSNumber *state;


//传入下载地址 实例化下载对象
- (instancetype)initWithDownloadUrlStr:(NSString *)urlStr;

-(void)startDownload;//开始下载
-(void)pauseDownload;//暂停下载
-(void)resumeDownload;//继续下载
-(void)cancelDownload;//取消下载
@end
