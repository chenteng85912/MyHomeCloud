//
//  TYKYUILibrary.h
//  webhall
//
//  Created by tjsoft on 2017/3/24.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//


@class  MJRefreshNormalHeader;

@interface CTTool : NSObject

//导航栏加边框文字按钮
+ (UIButton *)makeCustomRightBtn:(NSString *)title target:(id)target sel:(SEL)actionName;

//等待提示
+ (void)showKeyWindowHUD:(NSString *)msg;

//移除提示
+ (void)removeKeyWindowHUD;

//封装明杰刷新
+ (MJRefreshNormalHeader *)makeMJRefeshWithTarget:(id)root andMethod:(SEL)methodName;

//应用图标
+ (UIImage *)iconImage;

//按宽度裁剪图片
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//裁剪图片
+ (UIImage *)scaleImage:(UIImage *)img toSize:(CGSize)size;

//手机号合法验证
+ (BOOL)isValidateMobile:(NSString *)mobile;

//图片存储地址
+ (NSString *)imagePathWithImageName:(NSString *)imageName;

//根据文件ID删除文件
+ (void)deleteFile:(NSString *)fileId complete:(void(^)(void))completeHandle;
@end
