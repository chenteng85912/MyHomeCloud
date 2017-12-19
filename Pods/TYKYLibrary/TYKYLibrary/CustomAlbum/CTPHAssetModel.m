//
//  AlbumModel.m
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CTPHAssetModel.h"

@implementation CTPHAssetModel

+ (instancetype)initWithAsset:(PHAsset *)asset{
    return [[self alloc] initWithAsset:asset];
}
- (instancetype)initWithAsset:(PHAsset *)asset{
    self = [super init];
    if (self) {
        _asset = asset;
        _photoName =  [asset valueForKey:@"filename"];
    }
    return self;
}
@end
