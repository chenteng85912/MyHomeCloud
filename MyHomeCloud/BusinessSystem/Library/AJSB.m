//
//  AJSB.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/6/12.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJSB.h"
#import "AJLoginViewController.h"

@implementation AJSB
//打开登录界面
+ (void)goLoginViewComplete:(void (^)(void))callBack{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AJLoginViewController *vc  = [AJLoginViewController new];
        vc.backBlock = callBack;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
            [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:nav animated:YES completion:nil];
            
        }else{
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
            
        }
    });
    
}
@end
