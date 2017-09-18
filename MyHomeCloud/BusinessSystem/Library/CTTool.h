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

//应用名称
+ (NSString *)appName;

//按宽度裁剪图片
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//裁剪图片
+ (UIImage *)scaleImage:(UIImage *)img toSize:(CGSize)size;

//手机号合法验证
+ (BOOL)isValidateMobile:(NSString *)mobile;

//邮箱验证
+ (BOOL)validateEmail:(NSString *)email;

//拨打电话
+ (void)takePhoneNumber:(NSString *)phoneNum;

//字典过滤
+ (NSMutableDictionary *)filterDic:(NSDictionary *)inputDic;

//获取最顶部控制器
+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc;

//密码正则验证
+ (BOOL)isValidatePassword:(NSString *)password;

//移除搜索框边框
+ (void)removeSearchBorder:(UISearchBar *)searchBar;

@end
