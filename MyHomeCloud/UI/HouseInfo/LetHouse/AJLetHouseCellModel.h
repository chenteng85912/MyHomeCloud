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
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) NSString *houseDes;
@property (strong, nonatomic) NSString *letPrice;
@property (strong, nonatomic) NSString *unitPrice;

@property (assign, nonatomic) CGRect nameFrame;
@property (assign, nonatomic) CGRect subFrame;
@property (assign, nonatomic) CGRect desFrame;
@property (assign, nonatomic) CGRect letFrame;
@property (assign, nonatomic) CGRect unitFrame;
@property (assign, nonatomic) CGRect imgFrame;
@property (assign, nonatomic) CGRect userHeadFrame;
@end
