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


//根据文件ID删除文件
+ (void)deleteFile:(NSString *)fileId complete:(void(^)(void))completeHandle{
    NSString *delCql = [NSString stringWithFormat:@"delete from _File where objectId = '%@'",fileId];
    [AVQuery doCloudQueryInBackgroundWithCQL:delCql callback:^(AVCloudQueryResult *result, NSError *error) {
        if (!error) {
            if (completeHandle) {
                completeHandle();
            }
            debugLog(@"文件删除成功");
        }
        
    }];
    
}
@end
