//
//  AJAddPicturesViewController.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/7/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CTBaseViewController.h"

@class AJHouseInfoViewController;
@interface AJAddPicturesViewController : CTBaseViewController

@property (assign, nonatomic) BOOL isEditModal;
@property (strong, nonatomic) AVObject *houseInfo;//当前房源信息
@property (strong, nonatomic) AJHouseInfoViewController *houseInfoVC;

@end
