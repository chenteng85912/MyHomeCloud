//
//  AJLetHouseCellModel.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/6.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJTbViewCellModel.h"

@interface AJLetHouseCellModel : AJTbViewCellModel

@property (strong, nonatomic) NSString *houseName;
@property (strong, nonatomic) NSString *houseInfo;
@property (strong, nonatomic) NSString *houseDes;
@property (strong, nonatomic) NSString *letPrice;
@property (strong, nonatomic) NSString *houseTag;

@property (assign, nonatomic) CGRect nameFrame;
@property (assign, nonatomic) CGRect infoFrame;
@property (assign, nonatomic) CGRect desFrame;
@property (assign, nonatomic) CGRect priceFrame;
@property (assign, nonatomic) CGRect tagFrame;
@property (assign, nonatomic) CGRect imgFrame;

@end
