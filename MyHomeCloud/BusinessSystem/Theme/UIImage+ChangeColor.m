//
//  UIImage+ChangeColor.m
//  TYKYWallBaseSDK
//
//  Created by Hdd on 2017/8/30.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "UIImage+ChangeColor.h"
#import "TYKYThemeScheme.h"

@implementation UIImage (ChangeColor)

//非纯色使用 保持灰度信息
- (UIImage *)imageChangeThemeColor{
    
    if ([[TYKYThemeScheme currentColorKey] isEqualToString:[TYKYThemeScheme colorArray][1]]) {
        return self;

    }
     return  [self imageChangeColor:NavigationBarColor WithBlendModel:kCGBlendModeOverlay];
    
}


-(UIImage *)imageChangeThemePureColor{
    
    if ([[TYKYThemeScheme currentColorKey] isEqualToString:[TYKYThemeScheme colorArray][1]]) {
        return self;
        
    }
    return  [self imageChangeColor:NavigationBarColor WithBlendModel:kCGBlendModeDestinationIn];
    
}


-(UIImage*)imageChangeColor:(UIColor *)color WithBlendModel:(CGBlendMode)blendModel
{
    //获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    //画笔沾取颜色
    [color setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //绘制一次
    [self drawInRect:bounds blendMode:blendModel alpha:1.0f];
    if (blendModel != kCGBlendModeDestinationIn ) {
        //再绘制一次 保持透明度
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
