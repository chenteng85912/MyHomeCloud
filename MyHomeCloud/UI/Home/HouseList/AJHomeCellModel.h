//
//  AJHomeCellModel.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJTbViewCellModel.h"

@interface AJHomeCellModel : AJTbViewCellModel

@property (strong, nonatomic) NSString *houseName;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) NSString *houseDes;
@property (strong, nonatomic) NSString *totalPrice;
@property (strong, nonatomic) NSString *unitPrice;

@property (assign, nonatomic) CGRect nameFrame;
@property (assign, nonatomic) CGRect subFrame;
@property (assign, nonatomic) CGRect desFrame;
@property (assign, nonatomic) CGRect totalFrame;
@property (assign, nonatomic) CGRect unitFrame;
@property (assign, nonatomic) CGRect imgFrame;
@property (assign, nonatomic) CGRect userHeadFrame;


@end
