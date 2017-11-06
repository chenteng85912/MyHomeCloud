//
//  ALAsset+HEIC_TO_JPEG.h
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/10/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface ALAsset (HEIC_TO_JPEG)

//图片名称
- (NSString *)imageName;

//HEIC图片转换
- (UIImage*)changePhotoHEICImageToJPEG;

@end
