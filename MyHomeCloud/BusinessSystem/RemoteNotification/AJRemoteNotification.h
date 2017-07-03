//
//  TYKYRemoteNotification.h
//  webhall
//
//  Created by tjsoft on 2017/4/11.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AJRemoteNotification : NSObject

//注册极光推送
+ (void)registerJPush;

//极光推送注册通道ID
+ (void)registerJGNotification:(NSData *)deviceToken;

//注册通知
+ (void)registerRemoteNotification;

//检测用户是否打开通知
+ (void)checkUserNotificationSetting;

@end
