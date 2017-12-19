//
//  ONEPhoto.h
//
//  Created by Apple on 16/7/15.
//  Copyright © 2016年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CTONEPhotoDelegate <NSObject>

@optional
//传出图片和图片名称，1、打开系统相册传出图片实际名称 2、拍照传出时间戳生成的名称
- (void)sendOnePhoto:(UIImage *)image
       withImageName:(NSString *)imageName;

//传出视频路径/视频名称/视频缩略图
- (void)sendMediaPath:(NSString *)videoPath
             fileName:(NSString *)fileName
             thumeImg:(UIImage *)img;

@end

@interface CTONEPhoto : NSObject

//打开系统摄像头
+ (void)openCameraWithDelegate:(id <CTONEPhotoDelegate>)rootVC
                     editModal:(BOOL)enableEdit;

//打开系统相册（仅仅图片）
+ (void)openAlbumWithDelegate:(id <CTONEPhotoDelegate>)rootVC
                    editModal:(BOOL)enableEdit;

//打开系统相册（包括视频）
+ (void)openAlbumWithVideoWithDelegate:(id <CTONEPhotoDelegate>)rootVC;

//打开系统相册里面的视频
+ (void)openAlbumVideoWithDelegate:(id<CTONEPhotoDelegate>)rootVC;

@end
