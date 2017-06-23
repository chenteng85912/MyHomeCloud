//
//  TYKYUMShareUtil.m
//  webhall
//
//  Created by DD Hong  on 2017/4/13.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "AJUMShareUtil.h"

NSString *const APP_STORE_URL = @"https://itunes.apple.com/cn/app/安家屋/id1251844754?mt=8";

@implementation AJUMShareUtil

+ (BOOL)isWechatInstalled{
    NSString *wechatStr = [NSString stringWithFormat:@"weixin://%@",UMWEIXINKEY];
    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] || ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:wechatStr]]) {
        return NO;
    }
    return YES;
}

//分享
+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[CTTool appName] descr:@"" thumImage:[CTTool iconImage]];
    //苹果商店地址
    shareObject.webpageUrl = APP_STORE_URL;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            if (error.code == 2009 ) {
                [KEYWINDOW showTips:@"取消分享" withState:TYKYHUDModeSuccess complete:nil];
                
            }
            else{
                [KEYWINDOW showTips:@"分享失败" withState:TYKYHUDModeSuccess complete:nil];
                
            }
        }else{
            [KEYWINDOW showTips:@"分享成功" withState:TYKYHUDModeSuccess complete:nil];
           
        }
        
    }];
}

//分享微信聊天
+ (void)shareWechatSession{
    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];

}
//分享朋友圈
+ (void)shareWechatTimeLine
{
   
    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];

}


@end
