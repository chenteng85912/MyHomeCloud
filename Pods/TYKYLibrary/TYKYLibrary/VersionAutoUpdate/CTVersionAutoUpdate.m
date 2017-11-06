//
//  TJVersionAutoUpdate.m
//  TAIJIToolsFramework
//
//  Created by 腾 on 16/11/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CTVersionAutoUpdate.h"
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "CTRequest.h"

NSString *const ROOT_APP_STORE  =  @"http://itunes.apple.com/lookup?id=%@"; //获取应用相关信息的地址
NSString *const APP_STORE_URL  = @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8";//苹果商店跳转地址

@interface CTVersionAutoUpdate ()<SKStoreProductViewControllerDelegate>
@property (assign, nonatomic) OpenStoreStyle storeStyle;
@property (strong, nonatomic) NSString *appId;

@end
@implementation CTVersionAutoUpdate

static CTVersionAutoUpdate *VERSION = nil;

+ (void)sharedVersion
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        VERSION = [[self alloc] init];
        
    });
    
}

//版本更新
+ (void)checkAppStoreVersion:(NSString *)appId openStoreStyle:(OpenStoreStyle)showStyle{
    if (!appId&&[appId isEqualToString:@""]) {
        return;
    }
    [self sharedVersion];
    VERSION.storeStyle = showStyle;
    VERSION.appId = appId;
    NSString *appUrl = [NSString stringWithFormat:ROOT_APP_STORE,appId];
    [CTRequest sendGetRequestWithUrl:appUrl complete:^(NSError *error, NSDictionary *objectDic) {
        if (error) {
            return;
            
        }
        if (!objectDic) {
            return;
        }
        [self checkVersionInfo:objectDic];
    }];
   
}
//版本号比对
+ (void)checkVersionInfo:(NSDictionary *)versionDic{
    NSArray *verArray = versionDic[@"results"];
    if (verArray.count==0) {
        return;
    }
    NSString *storeVersion = [verArray[0] objectForKey:@"version"];//苹果商店最新版本号
    NSString *localVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//当前版本号
    if (!storeVersion) {
        return;
    }
    BOOL isNeedUpdate = NO;
    //分割字符串
    NSArray *curentVersionArr = [localVersion componentsSeparatedByString:@"."];  //当前版本
    NSArray *appStoreVersionArr = [storeVersion componentsSeparatedByString:@"."];//比较版本
    NSInteger count = curentVersionArr.count>appStoreVersionArr.count?appStoreVersionArr.count:curentVersionArr.count;
    
    BOOL isEqual=false;
    for (int i=0; i<count; i++) {
        NSInteger curV = [curentVersionArr[i] integerValue];
        NSInteger appV = [appStoreVersionArr[i] integerValue];
        if (curV==appV) {
            isEqual = YES;
        }else{
            isEqual = NO;
            
        }
        if (appV>curV) {
            isNeedUpdate = YES;
            break;
        }
    }
    if (!isNeedUpdate&&isEqual&&appStoreVersionArr.count>curentVersionArr.count) {
        
        isNeedUpdate = YES;
        
    }
    if (isNeedUpdate) {
        [self openAPPStore];
       
    }
}

//打开苹果商店
+ (void)openAPPStore{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"有新版本可以更新哦!" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"下次吧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (VERSION.storeStyle==OpenAppStoreInApp) {
            [self openAppStoreInApp];
            return;
        }
        NSURL *appUrl = [NSURL URLWithString:[NSString stringWithFormat:APP_STORE_URL,VERSION.appId]];
        if ([[UIApplication sharedApplication] canOpenURL:appUrl]) {
            [[UIApplication sharedApplication] openURL:appUrl];
            VERSION = nil;
        }
        
    }]];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    
}

//应用内部打开苹果商店 真机调试
+ (void)openAppStoreInApp{
    
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    storeProductViewContorller.delegate = VERSION;
    
    //加载一个新的视图展示
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [storeProductViewContorller loadProductWithParameters:
         //appId
         @{SKStoreProductParameterITunesItemIdentifier: VERSION.appId } completionBlock:^(BOOL result, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                if(error){
                     return ;
                 }
                 //AS应用界面
                 [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:storeProductViewContorller animated:YES completion:nil];
                 
             });
             
         }];
        
    });
}
//取消苹果商店
#pragma mark SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:^{
        VERSION = nil;
    }];
}

@end
