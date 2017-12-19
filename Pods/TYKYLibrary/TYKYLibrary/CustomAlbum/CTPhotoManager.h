//
//  PhotosDataCenter.h
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPhotosConfig.h"
#import "CTCollectionModel.h"

@protocol CTSendPhotosProtocol <NSObject>
@optional
/**
 传出图片字典
 @param imageDic key为图片名称，value为对应的图片 图片顺序和选择顺序可能不同
 */
- (void)sendImageDictionary:(NSDictionary <NSString *,UIImage*> *_Nullable)imageDic;

//传出图片数组
- (void)sendImageArray:(NSMutableArray <UIImage *> *_Nullable)imgArray;

//传出图片data数组
- (void)sendImageDataArray:(NSMutableArray <NSData *> *_Nullable)imgDataArray;

@end

@interface CTPhotoManager : NSObject

/**
 获取相册分组
 
 @param groupsBlock 返回相册分组
 */
+ (void)fetchDefaultAllPhotosGroup:(void (^_Nullable)(NSArray<PHAssetCollection *> * _Nonnull groupArray))groupsBlock;


/**
 发送图片

 @param collectionModel 某个相册的数据
 @param handlBlock 回调 dismiss
 */
+ (void)sendImageData:(CTCollectionModel *_Nullable)collectionModel
             complete:(dispatch_block_t _Nullable )handlBlock;

//获取代理
+ (id <CTSendPhotosProtocol>)delegate;

//设置代理
+ (void)setDelegate:(id <CTSendPhotosProtocol>)delegate;

@end
