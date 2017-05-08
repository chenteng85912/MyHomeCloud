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

#define ROOT_APP_STORE       @"http://itunes.apple.com/lookup?id=%@" //获取应用相关信息的地址
#define APP_STORE_URL   @"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id%@?mt=8"//苹果商店跳转地址

static CTVersionAutoUpdate *version;

@interface CTVersionAutoUpdate ()<SKStoreProductViewControllerDelegate>
@property (assign, nonatomic) BOOL isOpenInApp;
@property (strong, nonatomic) NSString *appId;

@end
@implementation CTVersionAutoUpdate
+ (CTVersionAutoUpdate *)sharedVersion
{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            version = [[self alloc] init];
            
        });
    }
    
    return version;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [super allocWithZone:zone];
    });
    return version;
}
- (id)copyWithZone:(NSZone *)zone
{
    return version;
}

//版本更新
- (void)checkAppStoreVersion:(NSString *)appId openStoreStyle:(OpenStoreStyle)showStyle{
    version.isOpenInApp = showStyle;
    version.appId = appId;
    NSString *appUrl = [NSString stringWithFormat:ROOT_APP_STORE,appId];
    [[CTRequest new] sendGetRequestWithUrl:appUrl complete:^(NSError *error, NSDictionary *objectDic) {
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
- (void)checkVersionInfo:(NSDictionary *)versionDic{
    NSArray *verArray = versionDic[@"results"];
    if (verArray.count==0) {
        return;
    }
    NSString *storeVersion = [verArray[0] objectForKey:@"version"];//苹果商店最新版本号
    NSString *localVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//当前版本号
    if (!storeVersion) {
        return;
    }
    NSArray *localArray = [localVersion componentsSeparatedByString:@"."];
    NSArray *newArray = [storeVersion componentsSeparatedByString:@"."];
    BOOL update = NO;
    if (newArray.count==localArray.count) {
        BOOL needUpdate = YES;
        for (int i =0; i<localArray.count; i++) {
            for (int j =0; j<newArray.count; j++) {
                if (i==j) {
                    
                    if ([localArray[i] integerValue] >= [newArray[j] integerValue]) {
                        needUpdate = NO;
                    }else{
                        if (needUpdate) {
                            update = YES;
                        }
                    }
                }
            }
        }

    }else if (newArray.count>localArray.count){
        for (int i =0; i<localArray.count; i++) {
            for (int j =0; j<newArray.count; j++) {
                if (i==j) {
                    
                    if ([localArray[i] integerValue] < [newArray[j] integerValue]) {
                        update = YES;
                        break;
                    }
                }else if (i==localArray.count-1&&j>i){
                    if (!update) {
                        update = YES;
                    }
                }
            }
        }

       
    }else{
        for (int i =0; i<newArray.count; i++) {
            for (int j =0; j<localArray.count; j++) {
                if (i==j) {
                    
                    if ([localArray[i] integerValue] < [newArray[j] integerValue]) {
                        update = YES;
                        break;
                    }
                }
            }
        }

    }
    if (update) {
        [self openAPPStore];
       
    }
    
}


//打开苹果商店
- (void)openAPPStore{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"有新版本可以更新哦!" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"下次吧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_isOpenInApp) {
            [self openAppStoreInApp];
            return;
        }
        NSURL *appUrl = [NSURL URLWithString:[NSString stringWithFormat:APP_STORE_URL,version.appId]];
        if ([[UIApplication sharedApplication] canOpenURL:appUrl]) {
            [[UIApplication sharedApplication] openURL:appUrl];
        }
        
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

//应用内部打开苹果商店 真机调试
- (void)openAppStoreInApp{
    
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    storeProductViewContorller.delegate = self;
    
    //加载一个新的视图展示
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [storeProductViewContorller loadProductWithParameters:
         //appId
         @{SKStoreProductParameterITunesItemIdentifier: version.appId } completionBlock:^(BOOL result, NSError *error) {
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
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
