//
//  AJLetHouseCellModel.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/6.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJTbViewCellModel.h"

@interface AJLetHouseCellModel : AJTbViewCellModel

@property (strong, nonatomic) NSString *houseName;//名称
@property (strong, nonatomic) NSString *houseInfo;//基本信息
@property (strong, nonatomic) NSString *houseDes;//描述
@property (strong, nonatomic) NSString *letPrice;//租金
@property (strong, nonatomic) NSString *houseTag1;//标签1
@property (strong, nonatomic) NSString *houseTag2;//标签2
@property (strong, nonatomic) NSString *houseTag3;//标签3

@property (assign, nonatomic) CGRect nameFrame;
@property (assign, nonatomic) CGRect infoFrame;
@property (assign, nonatomic) CGRect desFrame;
@property (assign, nonatomic) CGRect priceFrame;
@property (assign, nonatomic) CGRect imgFrame;

@property (assign, nonatomic) CGRect tag1Frame;
@property (assign, nonatomic) CGRect tag2Frame;
@property (assign, nonatomic) CGRect tag3Frame;

@end
