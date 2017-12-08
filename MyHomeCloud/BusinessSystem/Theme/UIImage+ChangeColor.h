//
//  UIImage+ChangeColor.h
//  TYKYWallBaseSDK
//
//  Created by Hdd on 2017/8/30.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ChangeColor)

#pragma mark 换肤

-(UIImage *)imageChangeThemeColor;

//纯色
-(UIImage *)imageChangeThemePureColor;

-(UIImage*)imageChangeColor:(UIColor *)color WithBlendModel:(CGBlendMode)blendModel;


@end
