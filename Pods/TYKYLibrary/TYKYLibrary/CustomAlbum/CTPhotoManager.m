//
//  PhotosDataCenter.m
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CTPhotoManager.h"

@implementation CTPhotoManager

static id<CTSendPhotosProtocol>CTDelegate = nil;
+ (void)setDelegate:(id<CTSendPhotosProtocol>)delegate{
    CTDelegate = delegate;
}
+ (id <CTSendPhotosProtocol>)delegate{
    return CTDelegate;
}
+ (void)fetchDefaultAllPhotosGroup:(void (^)(NSArray<PHAssetCollection *> * _Nonnull groupArray))groupsBlock
{
    
    [self fetchDefaultPhotosGroup:^(NSArray<PHAssetCollection *> * _Nonnull defaultGroups) {
        
        if ([NSThread isMainThread])
        {
            groupsBlock(defaultGroups);
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
             groupsBlock(defaultGroups);
            });
        });
       
    }];
    
}

+ (void)fetchDefaultPhotosGroup:(void (^)(NSArray<PHAssetCollection *> * _Nonnull))groups
{
    __block NSMutableArray <PHAssetCollection *> * defaultAllGroups = [NSMutableArray arrayWithCapacity:0];

    [self fetchBasePhotosGroup:^(NSArray<PHAssetCollection *> * _Nullable result) {
        
        [defaultAllGroups addObjectsFromArray:result];
        
        //遍历自定义的组
        PHFetchResult *userResult = [PHCollection fetchTopLevelUserCollectionsWithOptions:[PHFetchOptions new]];
        for (PHAssetCollection *asset in userResult) {
            [defaultAllGroups addObject:asset];

        }
        //遍历相册组 无照片的排后面
        [defaultAllGroups enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHFetchResult * assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:nil];
            NSUInteger count = [assetResult countOfAssetsWithMediaType:PHAssetMediaTypeImage];
            if (count==0) {
                [defaultAllGroups insertObject:obj atIndex:defaultAllGroups.count-1];
                [defaultAllGroups removeObjectAtIndex:idx];
            }
            if (idx==defaultAllGroups.count-1) {
                groups([NSArray arrayWithArray:defaultAllGroups]);
            }
        }];
       
        
    }];
}
/** 获取最基本的智能分组 */
+ (void)fetchBasePhotosGroup:(void(^)(NSArray<PHAssetCollection *> * _Nullable  result))completeBlock
{
    //进行检测
    if (![CTSavePhotos checkAuthorityOfAblum]) {
        return;
    }
    //获得智能分组
    PHFetchResult * smartGroups = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    [self filterGroup:smartGroups complete:^(NSArray<PHAssetCollection *>  * _Nonnull results) {
        completeBlock(results);
    }];
    
}
// 将configuration属性中的类别进行筛选
+ (void)filterGroup:(PHFetchResult<PHAssetCollection *> *)fetchResult
           complete:(void (^)(NSArray<PHAssetCollection *>  * _Nonnull results))groups
{
    __block  NSMutableArray <PHAssetCollection *> * preparationCollections = [NSMutableArray arrayWithCapacity:0];
    
    [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *subType = [CTPhotosConfiguration collectionSubTypeStr:obj.assetCollectionSubtype];
        
        if ([CTPhotosConfiguration.groupNamesConfig containsObject:subType]) {
            [preparationCollections addObject:obj];

        }
        
        if (idx == fetchResult.count - 1)
        {
            groups([NSArray arrayWithArray:preparationCollections]);
            preparationCollections  = nil;
        }
        
    }];
    
}

//发送图片
+ (void)sendImageData:(CTCollectionModel *)collectionModel
             complete:(dispatch_block_t _Nullable )handlBlock{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    __block NSMutableArray <NSData *>*temp = [NSMutableArray new];
    __block NSMutableArray <UIImage *>*tempImg = [NSMutableArray new];

    dispatch_group_async(group, queue, ^{
        for (CTPHAssetModel *model in collectionModel.selectedArray) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);

            [model.asset fetchOriginImageComplete:^(UIImage * _Nonnull originImg) {
                NSData *imgData;
                if (collectionModel.sendOriginImg) {
                    imgData = UIImageJPEGRepresentation(originImg, 1);
                }else{
                    imgData = UIImageJPEGRepresentation(originImg, CTPhotosConfiguration.outputphotosScale);
                }
                [tempImg addObject:[UIImage imageWithData:imgData]];
                [temp addObject:imgData];
                dispatch_semaphore_signal(sema);
                
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
      
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (CTDelegate&&[CTDelegate respondsToSelector:@selector(sendImageDataArray:)]) {
            [CTDelegate sendImageDataArray:temp];
        }
        if (CTDelegate&&[CTDelegate respondsToSelector:@selector(sendImageArray:)]) {
            [CTDelegate sendImageArray:tempImg];
        }
        if (handlBlock) {
            handlBlock();
        }
    });
}
@end
