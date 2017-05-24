//
//  AJHouseDetailsViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"

@interface AJHouseDetailsViewController : AJBaseTbViewController

@property (strong, nonatomic) AVObject *houseInfo;

@property (assign, nonatomic) BOOL isFromFav;//来自我的收藏

@end
