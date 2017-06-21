//
//  TYKYUMShareUtil.h
//  webhall
//
//  Created by DD Hong  on 2017/4/13.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

@interface AJUMShareUtil : NSObject

//是否安装微信
+ (BOOL)isWechatInstalled;

//分享微信朋友圈
+ (void)shareWechatTimeLine;

//分享微信聊天
+ (void)shareWechatSession;

@end
