//
//  AJHouseInfoEditViewController.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/7/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CTBaseViewController.h"
#import "AJHouseDetailsViewController.h"

@protocol AJHouseInfoEditViewControllerDelegate <NSObject>

- (void)refreshHouseInfo;

@end
@interface AJHouseInfoEditViewController : CTBaseViewController

@property (assign, nonatomic) DetailsHouseModal detailsModal;
@property (strong, nonatomic) AVObject *houseInfo;//当前房源信息
@property (weak, nonatomic) id<AJHouseInfoEditViewControllerDelegate> delegate;
@end
