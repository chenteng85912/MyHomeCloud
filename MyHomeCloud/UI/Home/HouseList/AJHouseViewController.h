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
@property (strong, nonatomic) NSString *searchKey;//房屋详情界面 进入查看更多相似房源 传入关键字

@end
