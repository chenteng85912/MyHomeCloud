//
//  AJReserverCellModel.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJTbViewCellModel.h"


@interface AJReserverCellModel : AJTbViewCellModel

@property (strong, nonatomic) NSString *houseName;//小区名称
@property (strong, nonatomic) NSString *rTime;//看房时间
@property (strong, nonatomic) NSString *agenterPhone;//经纪人电话
@property (strong, nonatomic) NSString *agenterName;//经纪人姓名
@property (strong, nonatomic) NSString *rUserName;//预约人姓名
@property (strong, nonatomic) NSString *rUserPhone;//预约人手机号
@property (strong, nonatomic) NSString *estateId;//房屋信息ID
@property (strong, nonatomic) NSString *creatTime;//发布时间
@property (strong, nonatomic) NSString *housePrice;//价格
@property (strong, nonatomic) NSString *pricType;//类型
@property (strong, nonatomic) NSString *houseAreaage;//面积

@property (strong, nonatomic) NSString *state;//0待确认 1已确认 2已撤销
@property (strong, nonatomic) NSString *stateStr;//0待确认 1已确认 2已撤销

@property (strong, nonatomic) UIColor *stateColor;

@end
