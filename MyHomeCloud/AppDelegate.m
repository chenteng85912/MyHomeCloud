//
//  AppDelegate.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/8.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AppDelegate.h"
#import "AjMainTabBarViewController.h"
#import "AJRemoteNotification.h"
#import "AJMessageBeanDao.h"
#import "AJMessageController.h"
#import "UMMobClick/MobClick.h" //友盟统计
#import <UMSocialCore/UMSocialCore.h>//友盟集成 微信分享

NSString *const AVOSCloudID = @"Q4xx9Pczn6UbtkFQttUzGfOV-gzGzoHsz";
NSString *const AVOSCloudKey = @"YUlG0aQ4gwl7DcuwopUraSnz";

NSString *const UMWEIXINAPPSECRET = @"1b701ce273624810d0f55296f19cd384";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AVOSCloud setApplicationId:AVOSCloudID clientKey:AVOSCloudKey];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.isSVPHUD = YES;
    if (self.isSVPHUD) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setFadeOutAnimationDuration:0.3];
        [SVProgressHUD popActivity];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [AjMainTabBarViewController new];
    [AJMessageBeanDao createTable];
    [self setUMWXSDK];
    
    [AJRemoteNotification registerRemoteNotification];
    [AJRemoteNotification registerJPush];

    self.areaArray = @[@"不限",@"莞城区",@"南城区",@"东城区",@"茶山镇",@"大朗镇",@"寮步镇",
                       @"常平镇",@"横沥镇",@"东坑镇",@"石排镇",@"企石镇",@"桥头镇",@"谢岗镇",
                       @"塘厦镇",@"樟木头镇",@"清溪镇",@"黄江镇",@"凤岗镇",
                       @"万江区",@"高埗镇",@"石碣镇",@"石龙镇",@"麻涌镇",@"中堂镇",@"望牛墩镇",@"洪梅镇",@"道滘镇",
                       @"虎门镇",@"厚街镇",@"长安镇",@"沙田镇"];
    
    [[CTVersionAutoUpdate sharedVersion] checkAppStoreVersion:@"1251844754" openStoreStyle:OpenAppStoreInApp];
    [self.window makeKeyAndVisible];

    return YES;
}
- (void)setUMWXSDK{
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMWEIXINKEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UMWEIXINKEY
                                       appSecret:UMWEIXINAPPSECRET redirectURL:@"http://mobile.umeng.com/social"];
    
}
//更新消息角标
- (void)updateMessageNumbers:(NSInteger)badgeNum{
    
    [(AjMainTabBarViewController *)self.window.rootViewController updateMessageNumbers:badgeNum];
  
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNum];
}
#pragma mark 注册推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    debugLog(@"注册设备推送deviceToken:%@",deviceToken);

    [AJRemoteNotification registerJGNotification:deviceToken];
    
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler{
    
    debugLog(@"应用状态 ===== %ld",(long)application.applicationState);
    //    [JPUSHService handleRemoteNotification:userInfo];
    
    handler(UIBackgroundFetchResultNewData);
    //通知栏无提示
    // 应用在前台UIApplicationStateActive，直接跳转到这里。
    // 应用在后台UIApplicationStateBackground，并且当后台设置aps字段里的 content-available 值为 1 时跳转到这里
    if (application.applicationState == UIApplicationStateActive||application.applicationState == UIApplicationStateBackground){
    }
    //杀死状态下，或者程序在后台，通知栏提示后，点击通知栏跳转到这里。
    if (application.applicationState == UIApplicationStateInactive)
    {
    }
    
    //预约消息
    if ([userInfo[@"msgType"] integerValue]==1&&![AVUser currentUser]) {
        return;
    }
    
    //保存推送消息
    [AJMessageBean saveNotice:userInfo];
}
- (NSMutableDictionary *)desInfo{
    if (_desInfo ==nil) {
        _desInfo = [NSMutableDictionary new];
        [_desInfo setObject:YEARS_COLOR         forKey:YEARS_DES];
        [_desInfo setObject:WATCH_COLOR         forKey:WATCH_DES];
        [_desInfo setObject:DECORATE_COLOR      forKey:DECORATE_DES];
        [_desInfo setObject:TRAFFIC_COLOR       forKey:TRAFFIC_DES];
        [_desInfo setObject:SCHOOL_COLOR        forKey:SCHOOL_DES];
        [_desInfo setObject:BUSSINESS_COLOR     forKey:BUSSINESS_DES];
        [_desInfo setObject:GOOD_LIVE_COLOR     forKey:GOOD_LIVE_DES];
        [_desInfo setObject:SUPPORT_COLOR       forKey:SUPPORT_ALL];
        [_desInfo setObject:SCHOOL_COLOR        forKey:RIPE_COMMUNITY];

    }
    return _desInfo;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//分享回调
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

@end
