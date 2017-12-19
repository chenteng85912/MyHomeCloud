//
//  AlbumModel.h
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPhotosConfig.h"
#import "PHAsset+CTPHAssetManager.h"

@interface CTPHAssetModel : NSObject

@property (nonatomic,strong) PHAsset *asset;

@property (nonatomic,strong) NSString *photoName;//图片名称

@property (nonatomic,assign) BOOL selected;//是否选中

+ (instancetype)initWithAsset:(PHAsset *)asset;

@end
