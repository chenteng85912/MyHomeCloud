//
//  UIView+TYKYPrompt.m
//  webhall
//
//  Created by DD Hong  on 2017/3/23.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "UIView+TYKYPrompt.h"
#import <MBProgressHUD/MBProgressHUD.h>

NSInteger const tipViewTag = 12345678;

@implementation UIView (TYKYPrompt)
//展示文字
- (void)showText:(NSString *)msg complete:(void(^)(void))handleComplete{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.color = [UIColor blackColor];
    
    hud.label.text = msg;
    hud.label.textColor = [UIColor whiteColor];
    
    hud.removeFromSuperViewOnHide = YES;
    
    [hud setOffset:CGPointMake(0, 200)];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        [hud hideAnimated:YES];
        if (handleComplete) {
            handleComplete ();
        }
    });
}
//展示成功或失败提示
- (void)showTips:(NSString *)msg withState:(TYKYHUDMode)HUDModel complete:(void(^)(void))handleComplete{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.color = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];

    UIImage *img = nil;
    
    if (HUDModel== TYKYHUDModeSuccess) {
        img = [UIImage imageNamed:@"success"];
    }else if (HUDModel== TYKYHUDModeFail){
        img = [UIImage imageNamed:@"fail"];
        
    }else{
        img = [UIImage imageNamed:@"warning"];

    }
    hud.customView = [[UIImageView alloc] initWithImage:img];
    
    if (msg.length>10) {
        hud.detailsLabel.text = msg;
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    }else{
        hud.label.text = msg;
    }
    hud.removeFromSuperViewOnHide = YES;
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        [hud hideAnimated:YES];
        if (handleComplete) {
            handleComplete ();
        }
    });
    
}
//带进度的提示
- (void)showProgressHUD:(float)progress tipMsg:(NSString *)msg{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (!hud) {

        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        hud.contentColor = [UIColor whiteColor];
        hud.bezelView.color = [UIColor blackColor];
        hud.label.text = msg;
        hud.removeFromSuperViewOnHide = YES;

    }

    hud.progress = progress;
}

//等待提示
- (void)showHUD:(NSString *)msg{
    //风火轮颜色修改
//    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    hud.label.text = msg;
    hud.removeFromSuperViewOnHide = YES;
    
}
//移除提示
- (void)removeHUD{
    
    [[MBProgressHUD HUDForView:self] hideAnimated:YES];
   
}

#pragma mark 无数据提示
// 暂无数据
- (void)addNoDataTipView{
    [self createNoticeView:@"暂无数据" imageName:@"NoDataNow"];
    
}
// 网络有问题提示
- (void)addInternetErrorTipView{
    
    [self createNoticeView:@"您似乎断开了网络连接" imageName:@"ErrorInternet"];
}

// 加载数据失败提示
- (void)addFailDataTipView{
    [self createNoticeView:@"加载数据失败" imageName:@"FailToGetData"];
}

// 消息界面-暂时没有新消息
- (void)addNoMessageTipView{
    
    [self createNoticeView:@"暂无消息" imageName:@"NoMessageNow"];
 
}
// 其他提示
- (void)addTipView:(NSString *)tipText{
    
    [self createNoticeView:tipText imageName:@"NoMessageNow"];
    
}
// 隐藏提示
- (void)hiddenTipsView{
    UIView *oldView = [self viewWithTag:tipViewTag];
    if (oldView) {
        [oldView removeFromSuperview];
    }
}

- (void)createNoticeView:(NSString *)tipText imageName:(NSString *)imgName
{
    UIView *oldView = [self viewWithTag:tipViewTag];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    
    UIView *nothing = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    nothing.backgroundColor = [UIColor clearColor];
    nothing.tag = tipViewTag;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 100, 40)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.text = tipText;
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.numberOfLines = 2;
    [nothing addSubview:tipLabel];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 60, 60)];
    imgView.image = [UIImage imageNamed:imgName];
   
    [nothing addSubview:imgView];
    
    [self addSubview:nothing];
    [self bringSubviewToFront:nothing];
    nothing.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
}

//淡出效果
- (void)showViewWithAnimation{
     self.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
        
    }];
}

@end
