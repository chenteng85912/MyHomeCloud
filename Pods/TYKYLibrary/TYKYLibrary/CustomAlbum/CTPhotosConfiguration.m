//
//  CTPhotosConfiguration.m
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/12.
//  Copyright © 2017年 CHENTENG. All rights reserved.
//

#import "CTPhotosConfiguration.h"
#import <Photos/Photos.h>

@implementation CTPhotosConfiguration

static NSArray <NSString *>*  groupNames;

+ (NSString *)collectionSubTypeStr:(NSInteger)subType{
   return [NSString stringWithFormat:@"%ld",(long)subType];
}

+ (NSArray *)groupNamesConfig
{
    groupNames = @[[self collectionSubTypeStr:PHAssetCollectionSubtypeSmartAlbumPanoramas],//全景照片
                   [self collectionSubTypeStr:PHAssetCollectionSubtypeSmartAlbumSelfPortraits],//自拍
                   [self collectionSubTypeStr:PHAssetCollectionSubtypeSmartAlbumScreenshots],// 屏幕快照
                   [self collectionSubTypeStr:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded],//最近添加
                   [self collectionSubTypeStr:PHAssetCollectionSubtypeSmartAlbumBursts],//连拍快照
                   [self collectionSubTypeStr:PHAssetCollectionSubtypeSmartAlbumUserLibrary]];//所有照片 

    return groupNames;
}

+ (CGFloat)outputphotosScale{
    return  0.6;
}

+ (NSInteger)maxNum{
    return  9;
}
@end
