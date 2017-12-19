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
+ (void)goLoginViewComplete:(dispatch_block_t)callBack{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AJLoginViewController *login  = [AJLoginViewController new];
        login.backBlock = callBack;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        
        UIViewController *rootVC = [CTTool getVisibleViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];

        [rootVC presentViewController:nav animated:YES completion:nil];

    });
    
}

//根据文件ID删除文件
+ (void)deleteFile:(NSString *)fileId complete:(void(^)(BOOL success, NSError *error))completeHandle{
    NSString *delCql = [NSString stringWithFormat:@"delete from _File where objectId = '%@'",fileId];
    
    [AVQuery doCloudQueryInBackgroundWithCQL:delCql callback:^(AVCloudQueryResult *result, NSError *error) {
        if (completeHandle) {
            if (error) {
                completeHandle(NO,error);

            }else{
                completeHandle(YES,nil);
                debugLog(@"文件删除成功");

            }
        }
        
    }];
    
}
@end
