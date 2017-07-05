//
//  TJMessageBean.m
//  TYKYTwoLearnOneDo
//
//  Created by tjsoft on 16/5/12.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import "AJMessageBean.h"
#import "AJMessageBeanDao.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AJMessageBean

- (instancetype)initNoticeWithUserInfo:(NSDictionary *)userInfo{
    self = [super init];
    if (self) {
        [self initDataWithUserInfo:[CTTool filterDic:userInfo]];
    }
    return self;
}

- (void)initDataWithUserInfo:(NSDictionary *)userInfo
{

    //极光推送
    if (userInfo[@"msg"]) {
        NSData *JSONData = [(NSString *)userInfo[@"msg"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *newdic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        userInfo = newdic[@"data"];
    }
    debugLog(@"通知内容 ===== %@",userInfo);

    _msgTitle = userInfo[@"title"];
    _msgContent = userInfo[@"message"];
    _msgType = userInfo[@"msgType"];
    _msgTime = userInfo[@"sendTime"];
    _msgUrl = userInfo[@"msgUrl"];
    //1预约 2新闻资讯 3系统通知
    if (_msgType.integerValue==2||_msgType.integerValue==3) {
        _userId = DEFAULT_USERID;
    }else{
        _userId = [AVUser currentUser].mobilePhoneNumber;

    }

}
- (NSMutableArray <AJMessageBean *> *)beansArray{
    if (_beansArray ==nil) {
        _beansArray = [NSMutableArray <AJMessageBean *> new];
    }
    return _beansArray;
}

#pragma mark 保存推送消息
+ (void)saveNotice:(NSDictionary *)userInfo{
    
    AJMessageBean *message = [[AJMessageBean alloc ] initNoticeWithUserInfo:userInfo];
    
    if ([AJMessageBeanDao  checkListMsgBean:message]) {
        [AJMessageBeanDao deleteOneNotice:message formType:ListMessageType];
    }
    [AJMessageBeanDao insertMsgBean:message formType:ListMessageType];
   
    BOOL suc = [AJMessageBeanDao insertMsgBean:message formType:DetailsMessageType];

    if (suc) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateMessage object:nil userInfo:userInfo];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//振动

    }else{
        
    }
}

@end
