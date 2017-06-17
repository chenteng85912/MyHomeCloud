//
//  AJReserverCellModel.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJTbViewCellModel.h"


@interface AJReserverCellModel : AJTbViewCellModel

@property (strong, nonatomic) NSString *houseName;
@property (strong, nonatomic) NSString *rTime;
@property (strong, nonatomic) NSString *agenterPhone;
@property (strong, nonatomic) NSString *agenterName;
@property (strong, nonatomic) NSString *rUserName;
@property (strong, nonatomic) NSString *rUserPhone;
@property (strong, nonatomic) NSString *estateId;
@property (strong, nonatomic) NSString *creatTime;

@property (strong, nonatomic) NSString *state;//0待确认 1已确认 2已撤销 
@property (strong, nonatomic) UIColor *stateColor;

@end
