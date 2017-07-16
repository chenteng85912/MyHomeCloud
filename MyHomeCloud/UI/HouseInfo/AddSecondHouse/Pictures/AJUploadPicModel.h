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
@property (nonatomic,strong) AVFile *picFile;
@property (nonatomic,assign) NSInteger percent;
@property (nonatomic,strong) NSString *objId;

@property (nonatomic,strong) NSNumber *state;//0未上传 1正在上传 2上传成功 3上传失败

@property (nonatomic,strong) NSString *picUrl;

@property (nonatomic,weak) id <AJUploadPicModelDelegate> delegate;

- (void)startUpload;
@end
