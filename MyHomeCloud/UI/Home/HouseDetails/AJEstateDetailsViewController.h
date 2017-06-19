//
//  AJEstateDetailsViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CTBaseViewController.h"
#import "AJHouseDetailsViewController.h"

@interface AJEstateDetailsViewController : CTBaseViewController

@property (strong, nonatomic) AVObject *houseInfo;
@property (assign, nonatomic) DetailsHouseModal detailsModal;
@property (assign, nonatomic) BOOL isFromReserver;
@end
