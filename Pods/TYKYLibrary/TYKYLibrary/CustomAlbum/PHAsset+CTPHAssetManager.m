//
//  PHAsset+CTPHAssetManager.m
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/14.
//  Copyright © 2017年 CHENTENG. All rights reserved.
//

#import "PHAsset+CTPHAssetManager.h"
#import <objc/runtime.h>
#import "CTPhotosConfig.h"

@implementation PHAsset (CTPHAssetManager)

- (NSMutableArray *)catcheArray
{
    return objc_getAssociatedObject(self, &@selector(catcheArray));
}

- (void)setCatcheArray:(NSMutableArray *)newArray
{
    objc_setAssociatedObject(self, &@selector(catcheArray), newArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)originPhotoSize
{
    return objc_getAssociatedObject(self, &@selector(originPhotoSize));
}

- (void)setOriginPhotoSize:(NSMutableDictionary *)newInfo
{
    objc_setAssociatedObject(self, &@selector(originPhotoSize), newInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)fetchThumbImageWithSize:(CGSize)size complete:(nonnull void (^)(UIImage * _Nullable img))completeBlock
{
    __weak typeof(self)copy_self = self;

    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize newSize = CGSizeMake(size.width * scale, size.height * scale);
    
    [[PHCachingImageManager defaultManager]requestImageForAsset:copy_self targetSize:newSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        completeBlock(result);
        
    }];
    
}

/**
 获取原图

 @param completeBlock 返回原图
 */
- (void)fetchOriginImageComplete:(void (^)( UIImage* _Nonnull originImg))completeBlock
{
    PHImageRequestOptions * option = [[PHImageRequestOptions alloc] init];
    
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    CGSize  size = CGSizeMake(self.pixelWidth, self.pixelHeight);
    
    [[PHCachingImageManager defaultManager] requestImageForAsset:self targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        completeBlock(result);
        
    }];
   
}

/**
 根据size获取缩略图

 @param size 希望显示的尺寸大小
 @param completeBlock 返回缩略图
 */
- (void)fetchPreviewImageWithSize:(CGSize)size
                      complete:(nonnull void (^)(UIImage * _Nullable thumbImg))completeBlock
{
    __weak typeof(self)copy_self = self;
    
    if (copy_self.catcheArray == nil)
    {
        copy_self.catcheArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize newSize = CGSizeMake(size.width * scale, size.height * scale);
 
    [[PHCachingImageManager defaultManager] requestImageForAsset:copy_self targetSize:newSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        completeBlock(result);
        
    }];
    
    if (![copy_self.catcheArray containsObject:[NSValue valueWithCGSize:size]])
    {
        [((PHCachingImageManager *)[PHCachingImageManager defaultManager])startCachingImagesForAssets:@[copy_self] targetSize:newSize contentMode:PHImageContentModeAspectFill options:nil];
        
        [copy_self.catcheArray addObject:[NSValue valueWithCGSize:newSize]];
    }
    
}

/**
 获取原始图片的大小

 @param completeBlock 返回图片大小
 */
- (void)fetchImageOriginSizeComplete:(void (^)(NSString * _Nonnull imageSize))completeBlock
{
    
    if (!self.originPhotoSize)
    {
        self.originPhotoSize = [NSMutableDictionary new];
    }
    
    NSString *fileName = [self valueForKey:@"filename"];
    //直接返回大小
    NSString * sizeRerturn = self.originPhotoSize[fileName];
    if (sizeRerturn) {
        completeBlock(sizeRerturn);
        return;

    }
    
    __weak typeof(self) weakSelf = self;
    [self fetchOriginImageDataComplete:^(NSData * _Nonnull imageData) {
        NSString * imageSize = photoSizeWithLength(@(imageData.length));
        
        //数组进行缓存
        weakSelf.originPhotoSize[fileName] = imageSize;
        //将大小传出，默认为btye
        completeBlock(imageSize);
    }];
   
}

- (void)fetchOriginImageDataComplete:(void (^)(NSData * _Nonnull imageData))completeBlock{
    //初始化option选项
    PHImageRequestOptions * option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:self options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        //将大小传出，默认为btye
        completeBlock(imageData);
        
    }];
}

#define CTPhotoStandard (1024.0)
static inline NSString * photoSizeWithLength(NSNumber *length)
{
    //转换成Btye
    NSUInteger btye = length.unsignedIntegerValue;
    
    //如果达到MB
    if (btye > CTPhotoStandard * CTPhotoStandard)
    {
        return [NSString stringWithFormat:@"%.1fMB",btye / CTPhotoStandard / CTPhotoStandard];
    }
    
    
    else if (btye > CTPhotoStandard)
    {
        return [NSString stringWithFormat:@"%.0fKB",btye / CTPhotoStandard];
    }
    
    else
    {
        return [NSString stringWithFormat:@"%@B",@(btye)];
    }
    
    return @"";
}
@end
