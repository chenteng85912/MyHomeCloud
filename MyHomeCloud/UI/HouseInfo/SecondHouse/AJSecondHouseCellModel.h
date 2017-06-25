//
//  AJHomeCellModel.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJTbViewCellModel.h"

@interface AJSecondHouseCellModel : AJTbViewCellModel

@property (strong, nonatomic) NSString *houseName;//名称
@property (strong, nonatomic) NSString *subTitle;//副标题
@property (strong, nonatomic) NSString *houseTag1;//标签1
@property (strong, nonatomic) NSString *houseTag2;//标签2
@property (strong, nonatomic) NSString *houseTag3;//标签3

@property (strong, nonatomic) NSString *totalPrice;//总价
@property (strong, nonatomic) NSString *unitPrice;//单价

@property (assign, nonatomic) CGRect nameFrame;
@property (assign, nonatomic) CGRect subFrame;
@property (assign, nonatomic) CGRect totalFrame;
@property (assign, nonatomic) CGRect unitFrame;
@property (assign, nonatomic) CGRect imgFrame;

@property (assign, nonatomic) CGRect tag1Frame;
@property (assign, nonatomic) CGRect tag2Frame;
@property (assign, nonatomic) CGRect tag3Frame;

@end
