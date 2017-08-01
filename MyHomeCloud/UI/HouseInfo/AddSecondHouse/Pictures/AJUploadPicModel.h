//
//  AJUploadPicModel.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/21.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AJUploadPicModelDelegate <NSObject>

- (void)refreshUploadProgress:(NSInteger)progress;
- (void)uploadSuccess:(BOOL)success;

@end

@interface AJUploadPicModel : NSObject
//原始数据
@property (nonatomic,strong) AVObject *orginObj;

@property (nonatomic,strong) AVFile *picFile;
@property (nonatomic,assign) NSInteger percent;
@property (nonatomic,strong) NSString *objId;

@property (nonatomic,strong) NSNumber *state;//0未上传 1正在上传 2上传成功 3上传失败

@property (nonatomic,strong) NSString *picUrl;

@property (nonatomic,weak) id <AJUploadPicModelDelegate> delegate;

//首页照片 上传后保存
@property (assign, nonatomic) BOOL isHome;

- (void)startUpload;
@end
