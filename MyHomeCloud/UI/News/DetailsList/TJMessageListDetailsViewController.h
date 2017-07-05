//
//  TJNoticeDetailsViewController.h
//  webhall
//
//  Created by Apple on 16/7/29.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//


@class AJMessageController;
@class AJMessageBean;

@interface TJMessageListDetailsViewController : CTBaseViewController

@property (nonatomic,strong) AJMessageBean *msgBean;
@property (nonatomic,strong) AJMessageController *megHome;

@property (nonatomic,strong) NSMutableArray <AJMessageBean *>*listArray;//消息类型列表 添加引用

@end
