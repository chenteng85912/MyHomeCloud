//
//  AJHonmeViewController.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/9.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"

typedef NS_ENUM(NSInteger,HouseShowModal) {
    HomeHouseModal,      //首页房源
    SearchHouseModal,    //搜索房源
};

@interface AJHouseViewController : AJBaseTbViewController
@property (assign, nonatomic) HouseShowModal showModal;

@end
