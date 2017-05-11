//
//  TYKYUILibrary.m
//  webhall
//
//  Created by tjsoft on 2017/3/24.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "CTTool.h"
#import "NSString+Extension.h"
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>

@implementation CTTool

//生成带边框的按钮
+ (UIButton *)makeCustomRightBtn:(NSString *)title target:(id)target sel:(SEL)actionName{
    CGFloat width = [title sizeWithMaxSize:CGSizeMake(200, 25) fontSize:15].width;
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width+8, 25)];
    [right setTitle:title forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    right.titleLabel.font = [UIFont systemFontOfSize:14];
    right.layer.masksToBounds = YES;
    right.layer.cornerRadius = 5.0;
    right.layer.borderWidth = 0.5;
    right.layer.borderColor = [UIColor blackColor].CGColor;
    
    [right addTarget:target action:actionName forControlEvents:UIControlEventTouchUpInside];
    return right;
}

//等待提示
+ (void)showKeyWindowHUD:(NSString *)msg{
    //风火轮颜色修改
   
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.bezelView.color = [UIColor blackColor];
        hud.label.textColor = [UIColor whiteColor];
        hud.contentColor = [UIColor whiteColor];
        hud.label.text = msg;
        hud.removeFromSuperViewOnHide = YES;
    }
    
}
//移除提示
+ (void)removeKeyWindowHUD{
  
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud) {
        [hud hideAnimated:YES];
    }
}

+ (MJRefreshNormalHeader *)makeMJRefeshWithTarget:(id)root andMethod:(SEL)methodName{
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc]init];
    [header setTitle:@"继续下拉以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
//    header.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"Avenir-Book" size:10];
//    header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    
    header.stateLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14];
    header.stateLabel.textColor = [UIColor blackColor];
    
    header.refreshingTarget = root;
    header.refreshingAction = methodName;
    
    return header;
}

//应用图标
+ (UIImage *)iconImage{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *iconStr = [[infoDic valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    return [UIImage imageNamed:iconStr];
}
@end
