//
//  UIImage+Scale.h
//  headset
//
//  Created by yin on 14-3-7.
//  Copyright (c) 2014年 深圳艾赛克科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

//按大小裁剪图片
- (UIImage*)scaleToSize:(CGSize)size;

//切图
- (UIImage*)getSubImage:(CGRect)rect;

//正常摆正图片方向
- (UIImage *)normalizedImage;

//旋转图片
- (UIImage *)makeOrientationImage:(UIImageOrientation)orientation;

//缩放图片
- (UIImage *)resizeImage;

//拉伸图片
- (UIImage *)resizableImage;

//调整方向
- (UIImage *)fixOrientation;

@end
