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

@end
