//
//  PHAsset+CTPHAssetManager.h
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/14.
//  Copyright © 2017年 CHENTENG. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (CTPHAssetManager)

/**
 根据size获取缩略图
 
 @param size 希望显示的尺寸大小
 @param completeBlock 返回缩略图
 */
- (void)fetchThumbImageWithSize:(CGSize)size
                       complete:(nonnull void (^)(UIImage * _Nullable thumbImg))completeBlock;
/**
 根据size获取缩略图
 
 @param size 希望显示的尺寸大小
 @param completeBlock 返回缩略图
 */
- (void)fetchPreviewImageWithSize:(CGSize)size
                         complete:(nonnull void (^)(UIImage * _Nullable thumbImg))completeBlock;
/**
 获取原图
 
 @param completeBlock 返回原图
 */
- (void)fetchOriginImageComplete:(void (^_Nullable)( UIImage* _Nonnull originImg))completeBlock;

/**
 获取原始图片的大小
 
 @param completeBlock 返回图片大小
 */
- (void)fetchImageOriginSizeComplete:(void (^_Nullable)(NSString * _Nonnull imageSize))completeBlock;

@end
