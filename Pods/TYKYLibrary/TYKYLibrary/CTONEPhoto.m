//
//  ONEPhoto.m
//
//  Created by Apple on 16/7/15.
//  Copyright © 2016年 腾. All rights reserved.
//

#import "CTONEPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CTSavePhotos.h"
#import "UIImage+Tools.h"

static CTONEPhoto *onePhoto = nil;

@interface CTONEPhoto ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@end

@implementation CTONEPhoto

+ (CTONEPhoto *)shareSigtonPhoto
{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            onePhoto = [[self alloc] init];
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = onePhoto;
            onePhoto.imagePicker = picker;
        });
    }
    
    return onePhoto;
}

- (void)openCamera:(UIViewController *)rootVC editModal:(BOOL)enableEdit{
    
    if (![[CTSavePhotos new] checkAuthorityOfCamera]) {
        return;
    }
    
    onePhoto.imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    onePhoto.imagePicker.allowsEditing = enableEdit;
  
    [rootVC presentViewController:onePhoto.imagePicker animated:YES completion:nil];
}
- (void)openAlbum:(UIViewController *)rootVC editModal:(BOOL)enableEdit{
    if (![[CTSavePhotos new] checkAuthorityOfAblum]) {
        return;
    }
    //onePhoto.imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    onePhoto.imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    onePhoto.imagePicker.allowsEditing = enableEdit;
    onePhoto.imagePicker.navigationBar.translucent = NO;
    onePhoto.imagePicker.navigationBar.tintColor = [UIColor blackColor];
    
    [rootVC presentViewController:onePhoto.imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = nil;
    if (picker.allowsEditing) {
        selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            selectedImage = [selectedImage normalizedImage];
        }
    }
   
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        NSString *imageName = [NSString stringWithFormat:@"%.f",[[NSDate new] timeIntervalSince1970]];
        if ([[CTSavePhotos new] checkAuthorityOfAblum]) {
            [[CTSavePhotos new] saveImageIntoAlbum:selectedImage];
        }
        [picker dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(sendOnePhoto:withImageName:)]) {
                [self.delegate sendOnePhoto:selectedImage withImageName:imageName];
            }
        }];
    }else{
        //相册 取出图片名称
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            NSString *imageName = [representation filename];
            NSLog(@"imageName : %@",imageName);
          [picker dismissViewControllerAnimated:YES completion:^{
              if ([self.delegate respondsToSelector:@selector(sendOnePhoto:withImageName:)]) {
                  [self.delegate sendOnePhoto:selectedImage withImageName:imageName];
              }
          }];
        };
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL resultBlock:resultblock failureBlock:nil];

    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
@end
