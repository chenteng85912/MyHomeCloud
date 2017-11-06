//
//  UIView-TYKYPrompt.h
//  webhall
//
//  Created by DD Hong  on 2017/3/23.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TYKYHUDMode) {
    TYKYHUDModeFail,//失败
    TYKYHUDModeSuccess,//成功
    TYKYHUDModeWarning//警告
   
};
@interface UIView (TYKYPrompt)

#pragma mark Toast

//展示文字
- (void)showText:(NSString *)msg
        complete:(dispatch_block_t)handleComplete;

- (void)showSVTips:(NSString *)msg
         withState:(TYKYHUDMode)HUDModel
          complete:(dispatch_block_t)handleComplete;

//展示成功或失败提示
- (void)showTips:(NSString *)msg withState:(TYKYHUDMode)HUDModel
        complete:(dispatch_block_t)handleComplete;

//等待提示
- (void)showHUD:(NSString *)msg;

//带进度的提示
- (void)showProgressHUD:(float)progress
                 tipMsg:(NSString *)msg;

//移除提示
- (void)removeHUD;

#pragma mark 无数据提示
// 暂无数据
- (void)addNoDataTipView;

// 网络有问题提示
- (void)addInternetErrorTipView;

// 其他提示
- (void)addTipView:(NSString *)tipText;

// 加载数据失败提示
- (void)addFailDataTipView;

// 消息界面-暂时没有新消息
- (void)addNoMessageTipView;

// 隐藏提示
- (void)hiddenTipsView;

//淡出效果
- (void)showViewWithAnimation;

@end
