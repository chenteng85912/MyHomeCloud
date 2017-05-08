//
//  ONEPhoto.h
//
//  Created by Apple on 16/7/15.
//  Copyright © 2016年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CTONEPhotoDelegate <NSObject>

//传出图片和图片名称，1、打开系统相册传出图片实际名称 2、拍照传出时间戳生成的名称
- (void)sendOnePhoto:(UIImage *)image withImageName:(NSString *)imageName;

@end

@interface CTONEPhoto : NSObject
@property (nonatomic,weak) id <CTONEPhotoDelegate> delegate;

+ (CTONEPhoto *)shareSigtonPhoto;

//打开系统摄像头
- (void)openCamera:(UIViewController *)rootVC editModal:(BOOL)enableEdit;
//打开系统相册
- (void)openAlbum:(UIViewController *)rootVC editModal:(BOOL)enableEdit;
@end
