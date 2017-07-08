//
//  TYKYRemoteNotification.m
//  webhall
//
//  Created by tjsoft on 2017/4/11.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "AJRemoteNotification.h"
#import "JPUSHService.h"

NSString *const TIME_KEY = @"time_key";

@implementation AJRemoteNotification

//注册通知
+ (void)registerRemoteNotification{
    
    UIUserNotificationSettings *Settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:Settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}
//1注册极光推送
+ (void)registerJPush{
    
    //触发 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:nil];
    
    [JPUSHService setupWithOption:nil appKey:JPUSH_AppKey
                          channel:@"App Store"
                 apsForProduction:jPushMode];
    
    
}
//2极光推送注册通道ID
+ (void)registerJGNotification:(NSData *)deviceToken{

    [JPUSHService registerDeviceToken:deviceToken];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        //设置标签 应用名称
        [JPUSHService setTags:[[NSSet alloc] initWithObjects:[CTTool appName], nil] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            
        } seq:[[NSDate new] timeIntervalSince1970]];
        debugLog(@"极光推送registrationID========== %@",registrationID);
        [[AVUser currentUser] setObject:registrationID forKey:USER_PUSH_ID];
        [[AVUser currentUser] saveInBackground];
    }];
    
}

//检测用户是否打开通知
+ (void)checkUserNotificationSetting{
    
    //打开了通知
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        
        return;
    }
    NSInteger oldTime = [MyUserDefaults integerForKey:TIME_KEY];
    NSInteger nowTime = [[NSDate new] timeIntervalSince1970];
    if ((nowTime-oldTime)<24*60*60) {
        return;
    }
    [MyUserDefaults setInteger:nowTime forKey:TIME_KEY];

    //用户关闭了推送通知 提醒用户前往打开通知设置
    NSString *title = [NSString stringWithFormat:@"\"%@\" 想给您发送推送通知",[CTTool appName]];
    [UIAlertController alertWithTitle:title message:@"\"通知\" 可能包括提醒、声音和图标标记。可以前往\"设置\"中设置" cancelButtonTitle:@"取消" otherButtonTitles:@[@"前往设置"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
                
            }
        }
    }];

}


@end
