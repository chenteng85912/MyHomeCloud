//
//  TJMessageBean.h
//  TYKYTwoLearnOneDo
//
//  Created by tjsoft on 16/5/12.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJMessageBean : NSObject

@property long _id;        //id主键
@property(nonatomic, strong) NSString *userId;          //用户ID

@property(nonatomic, strong) NSString *msgTitle;        //消息标题
@property(nonatomic, strong) NSString *msgContent;      //消息内容
@property(nonatomic, strong) NSString *msgType;         //消息类型
@property(nonatomic, strong) NSString *msgTime;         //消息时间
@property(nonatomic, strong) NSString *msgUrl;          //消息链接

@property(nonatomic, assign) BOOL isRead;       //是否已读

@property(nonatomic, strong) NSString *unReadNum;  //未读数量
@property(nonatomic, strong) NSMutableArray <AJMessageBean *> *beansArray;   //消息列表

//根据推送消息创建TJMessageBean
- (instancetype)initNoticeWithUserInfo:(NSDictionary *)userInfo;

//保存推送消息
+ (void)saveNotice:(NSDictionary *)userInfo;

@end
