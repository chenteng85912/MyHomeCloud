//
//  ALAsset+HEIC_TO_JPEG.m
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/10/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ALAsset+HEIC_TO_JPEG.h"

@implementation ALAsset (HEIC_TO_JPEG)

- (NSString *)imageName{
    NSString *assetImgName = self.defaultRepresentation.filename;
    NSLog(@"imageName : %@",assetImgName);

    if ([assetImgName.pathExtension isEqualToString:@"HEIC"]) {
        return [assetImgName stringByReplacingOccurrencesOfString:@"HEIC" withString:@"JPG"];
    }
    return assetImgName;
}
- (UIImage*)changePhotoHEICImageToJPEG{
    
    UIImage *assetImg = [UIImage imageWithCGImage:self.defaultRepresentation.fullScreenImage];
    NSString *assetImgName = self.defaultRepresentation.filename;
    //测试heic格式转换
    if (![assetImgName.pathExtension isEqualToString:@"HEIC"]) {
        return assetImg;
    }
    //heic格式转换
    UIImage *img = [self getPNGImage];
    
    return img;
}
- (UIImage *)getPNGImage{
    
    ALAssetRepresentation *image_representation = self.defaultRepresentation;
    uint8_t *buffer = (Byte*)malloc(image_representation.size);
    NSUInteger length = [image_representation getBytes:buffer fromOffset: 0.0  length:image_representation.size error:nil];
    
    if (length == 0)  {
        UIImage *assetImg = [UIImage imageWithCGImage:self.defaultRepresentation.fullScreenImage];
        
        return assetImg;
    }
    NSString *assetImgName = self.defaultRepresentation.filename;
    NSString *savedImgPath = [self getSavedImageLocalPath:assetImgName.stringByDeletingPathExtension];
    
    // buffer -> NSData object; free buffer afterwards
    NSData *adata = [[NSData alloc] initWithBytesNoCopy:buffer length:image_representation.size freeWhenDone:YES];
    
    //将Data数据保存到本地
    [adata writeToFile:savedImgPath atomically:YES];
    NSData *resaveImgData = [NSData dataWithContentsOfFile:savedImgPath];
    UIImage *resaveImg = [UIImage imageWithData:resaveImgData];
    
    //删除本地文件
    [[NSFileManager defaultManager] removeItemAtPath:savedImgPath error:nil];
    
    return resaveImg;
}

//获取本地地址
- (NSString*)getSavedImageLocalPath:(NSString *)imgName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectionary = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@.JPG",imgName];
    NSString *savedImgPath = [documentDirectionary stringByAppendingPathComponent:fileName];
    
    return savedImgPath;
}

@end
