//
//  UIImage+Tools.h
//  TAIJIToolsFramework
//
//  Created by 腾 on 16/12/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)

//正常摆正图片方向
- (UIImage *)normalizedImage;

//改变图片颜色
- (UIImage *)changeColor:(UIColor *)color;

//按大小裁剪图片
- (UIImage*)scaleToSize:(CGSize)size;

//旋转图片
- (UIImage *)makeOrientationImage:(UIImageOrientation)orientation;

//拉伸图片 不变形
- (UIImage *)resizeImage;

@end
