//
//  ONEPhoto.m
//
//  Created by Apple on 16/7/15.
//  Copyright © 2016年 腾. All rights reserved.
//

#import "CTONEPhoto.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CTSavePhotos.h"

@interface CTONEPhoto ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,weak) id <CTONEPhotoDelegate> delegate;

@end

@implementation CTONEPhoto
static CTONEPhoto *onePhoto = nil;

+ (void)sigtonPhoto
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        onePhoto = [[self alloc] init];
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.delegate = onePhoto;
        onePhoto.imagePicker = picker;
    });
    
}

//打开系统摄像头
+ (void)openCameraWithDelegate:(id <CTONEPhotoDelegate>)rootVC
                     editModal:(BOOL)enableEdit{

    if (![CTSavePhotos checkAuthorityOfCamera]) {
        return;
    }
    [self sigtonPhoto];
    onePhoto.delegate = rootVC;
    [self initImagePicker:UIImagePickerControllerSourceTypeCamera
                editModal:enableEdit];
  
}
//打开系统相册（仅仅图片）
+ (void)openAlbumWithDelegate:(id <CTONEPhotoDelegate>)rootVC
                    editModal:(BOOL)enableEdit{

    if (![CTSavePhotos checkAuthorityOfAblum]) {
        return;
    }
    [self sigtonPhoto];
    onePhoto.delegate = rootVC;

    [self initImagePicker:UIImagePickerControllerSourceTypePhotoLibrary
                editModal:enableEdit];

}
//打开系统相册（包括视频）
+ (void)openAlbumWithVideoWithDelegate:(id <CTONEPhotoDelegate>)rootVC{
    if (![CTSavePhotos checkAuthorityOfAblum]) {
        return;
    }
    [self sigtonPhoto];
    onePhoto.delegate = rootVC;

    [self initImagePicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum
                editModal:NO];

}
//打开系统相册里面的视频
+ (void)openAlbumVideoWithDelegate:(id<CTONEPhotoDelegate>)rootVC{
    if (![CTSavePhotos checkAuthorityOfAblum]) {
        return;
    }
    [self sigtonPhoto];
    onePhoto.delegate = rootVC;
    
    onePhoto.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    onePhoto.imagePicker.navigationBar.translucent = NO;
    onePhoto.imagePicker.navigationBar.tintColor = [UIColor blackColor];
    onePhoto.imagePicker.mediaTypes =  @[(NSString *)kUTTypeMovie];
    
    UIViewController *keywindow = [UIAlertController getVisibleViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
    if (keywindow) {
        [keywindow presentViewController:onePhoto.imagePicker animated:YES completion:nil];
    }
 
}

+ (void)initImagePicker:(UIImagePickerControllerSourceType)imagePickerType
              editModal:(BOOL)enableEdit{
    
    onePhoto.imagePicker.sourceType = imagePickerType;
    onePhoto.imagePicker.allowsEditing = enableEdit;
    
    if (imagePickerType == UIImagePickerControllerSourceTypePhotoLibrary
        ||imagePickerType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
        onePhoto.imagePicker.navigationBar.translucent = NO;
        onePhoto.imagePicker.navigationBar.tintColor = [UIColor blackColor];
        if (imagePickerType==UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
            onePhoto.imagePicker.mediaTypes =  @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
            
        }
    }
    
    UIViewController *rootVC = [UIAlertController getVisibleViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
    if (rootVC) {
        [rootVC presentViewController:onePhoto.imagePicker animated:YES completion:nil];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = nil;
    if (picker.allowsEditing) {
        selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            selectedImage = [self normalizedImage:selectedImage];
        }
    }
    //拍照
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //保存到相册
        if ([CTSavePhotos checkAuthorityOfAblum]) {
            [CTSavePhotos saveImageIntoAlbum:selectedImage];

        }
        
        NSString *imageName = [NSString stringWithFormat:@"%f.JPG",[[NSDate new]timeIntervalSince1970]];
        [picker dismissViewControllerAnimated:YES completion:^{
            if ([onePhoto.delegate respondsToSelector:@selector(sendOnePhoto:withImageName:)]) {
                [onePhoto.delegate sendOnePhoto:selectedImage withImageName:imageName];
            }
        }];
       
    }else{
        NSString *mediaType = info[UIImagePickerControllerMediaType];
        //图片
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            //相册 取出图片名称
            
            NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];

            PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageURL] options:nil];

            [self fetchOriginImage:result.firstObject complete:^(UIImage * _Nonnull originImg) {
                NSString *imageName = [result.firstObject valueForKey:@"filename"];
                if ([onePhoto.delegate respondsToSelector:@selector(sendOnePhoto:withImageName:)]) {
                    [onePhoto.delegate sendOnePhoto:originImg withImageName:imageName];
                }
                [onePhoto.imagePicker dismissViewControllerAnimated:YES completion:^{
                }];
            }];
        }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
            //视频
            NSURL *vedioURL = [info valueForKey:UIImagePickerControllerMediaURL];
            [onePhoto encode:vedioURL withBlock:^(NSString *fileFullPath, NSString *fileName) {
                [picker dismissViewControllerAnimated:YES completion:^{

                    if ([onePhoto.delegate respondsToSelector:@selector(sendMediaPath:fileName:thumeImg:)]) {
                        [onePhoto.delegate sendMediaPath:fileFullPath fileName:fileName thumeImg:[onePhoto getVideoThumb:fileFullPath]];
                    }
                }];
            }];
        }
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
}
- (void)encode:(NSURL *)url
     withBlock:(void (^) (NSString *fileFullPath, NSString *fileName))block
{
    
    NSURL *doneUrl =[NSURL new];
    //视频格式转换
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    NSString *mp4Quality = AVAssetExportPresetMediumQuality; //AVAssetExportPreset640x480;//
    if ([compatiblePresets containsObject:mp4Quality]){
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:mp4Quality];
        
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [NSString stringWithFormat:@"%.f.mp4", [[NSDate new] timeIntervalSince1970]];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%@", doc, fileName];
        
        doneUrl = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = doneUrl;
        exportSession.shouldOptimizeForNetworkUse = YES; //是否为网络传输优化
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    //格式转换失败
                    NSLog(@"视频格式转换失败");
                    break;
                }
                    
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"视频格式转换取消");
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    
                    //回主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"视频格式转换成功,视频路径：%@",mp4Path);

                        //block回调
                        if (block) {
                            block(mp4Path, fileName);
                        }
                    });
                    
                }
                    break;
                default:
                    break;
            }
            
        }];
    }
}
- (UIImage *)getVideoThumb:(NSString *)filePath{
    
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return shotImage;
    
}
//正常摆正图片方向
- (UIImage *)normalizedImage:(UIImage *)originImg {
    if (originImg.imageOrientation == UIImageOrientationUp)
        return originImg;
    
    UIGraphicsBeginImageContextWithOptions(originImg.size, NO, originImg.scale);
    [originImg drawInRect:(CGRect){0, 0, originImg.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

- (void)fetchOriginImage:(PHAsset *)asset
                complete:(void (^)( UIImage* _Nonnull originImg))completeBlock
{
    PHImageRequestOptions * option = [[PHImageRequestOptions alloc] init];
    
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    CGSize  size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        completeBlock(result);
        
    }];
    
}

@end
