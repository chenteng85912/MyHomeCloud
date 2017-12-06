//
//  ONEPhoto.m
//
//  Created by Apple on 16/7/15.
//  Copyright © 2016年 腾. All rights reserved.
//

#import "CTONEPhoto.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CTSavePhotos.h"
#import "UIImage+Tools.h"
#import "ALAsset+HEIC_TO_JPEG.h"

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
    
    [[UIApplication sharedApplication].keyWindow.rootViewController
     presentViewController:onePhoto.imagePicker animated:YES completion:nil];

}
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
+ (void)openAlbumWithVideoWithDelegate:(id <CTONEPhotoDelegate>)rootVC
                             editModal:(BOOL)enableEdit{
    if (![CTSavePhotos checkAuthorityOfAblum]) {
        return;
    }
    [self sigtonPhoto];
    onePhoto.delegate = rootVC;

    [self initImagePicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum
                editModal:enableEdit];

}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImage *selectedImage = nil;
    if (picker.allowsEditing) {
        selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            selectedImage = [selectedImage normalizedImage];
        }
    }
    //拍照
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
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
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
                [onePhoto sendImage:myasset];
            };
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:imageURL resultBlock:resultblock failureBlock:nil];

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
//图片处理
- (void)sendImage:(ALAsset *)myasset{
  
    UIImage *selectedImage = [myasset changePhotoHEICImageToJPEG];
    NSString *imageName = [myasset imageName];
    [onePhoto.imagePicker dismissViewControllerAnimated:YES completion:^{
        if ([onePhoto.delegate respondsToSelector:@selector(sendOnePhoto:withImageName:)]) {
            [onePhoto.delegate sendOnePhoto:selectedImage withImageName:imageName];
        }
    }];
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
        NSString *fileName = [NSString stringWithFormat:@"%f.mp4", [[NSDate new] timeIntervalSince1970]];
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

@end
