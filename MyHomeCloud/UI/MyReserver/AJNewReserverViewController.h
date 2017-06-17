//
//  AJNewReserverViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CTBaseViewController.h"
#import "AJMyReserverViewController.h"

@interface AJNewReserverViewController : CTBaseViewController
@property (strong, nonatomic) AVObject *houseInfo;//房源信息
@property (assign, nonatomic) UserReserverModal reserverModal;

@end
