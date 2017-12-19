//
//  SaveImageTool.m
//  webhall
//
//  Created by Apple on 2016/12/21.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import "CTSavePhotos.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>

@interface CTSavePhotos ()

@property (strong, nonatomic) NSString *APPNAME;

@end

@implementation CTSavePhotos

static CTSavePhotos *instance = nil;

+ (CTSavePhotos *)sigtonInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CTSavePhotos alloc] init];
    });
    return instance;
}

//保存图片到相册 自定义分类名称
+ (void)saveImageIntoAlbum:(UIImage *)image{
    
    instance = [self sigtonInstance];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.创建图片请求类(创建系统相册中新的图片)PHAssetCreationRequest
        // 把图片放在系统相册
        PHAssetCreationRequest *assetCreationRequest = [PHAssetCreationRequest creationRequestForAssetFromImage:image];
        
        // 2.创建相册请求类(修改相册)PHAssetCollectionChangeRequest
        PHAssetCollectionChangeRequest *assetCollectionChangeRequest = nil;
        
        // 获取之前相册
        PHAssetCollection *assetCollection = [self fetchAssetCollection:instance.APPNAME];
        // 判断是否已有相册
        if (assetCollection) {
            // 如果存在已有同名相册   指定这个相册,创建相册请求修改类
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        } else {
            //不存在,创建新的相册
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:instance.APPNAME];
        }
        // 3.把图片添加到相册中
        [assetCollectionChangeRequest addAssets:@[assetCreationRequest.placeholderForCreatedAsset]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            NSLog(@"图片保存成功");
        }
        
    }];

}
// 指定相册名称,获取相册
+ (PHAssetCollection *)fetchAssetCollection:(NSString *)title
{
    // 获取相簿中所有自定义相册
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //遍历相册,判断是否存在同名的相册
    for (PHAssetCollection *assetCollection in result) {
        if ([title isEqualToString:assetCollection.localizedTitle]) {
            //存在,就返回这个相册
            return assetCollection;
        }
    }
    return nil;
}

//检测相册权限
+ (BOOL)checkAuthorityOfAblum{

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        [self showAlertWithMessage:@"相册被禁止访问了，请前往设置进行更改" ];
        
        return NO ;
    }  else {
        return YES;
    }

}
//检测相机权限
+ (BOOL)checkAuthorityOfCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"没有可调用的相机");
        return NO;
    }

    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
    {
        [self showAlertWithMessage:@"相机被禁止访问了，请前往设置进行更改" ];
        return NO;
    }
   
    return YES;
   
}
//弹出前往设置提示
+ (void)showAlertWithMessage:(NSString *)msg{
    [UIAlertController alertWithTitle:@"温馨提示" message:msg cancelButtonTitle:@"取消" otherButtonTitles:@[@"前往设置"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }
    }];
}

//获取项目名称 作为相册分类
- (NSString *)APPNAME{
    if (!_APPNAME) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        _APPNAME = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    }
    return _APPNAME;
}

@end
