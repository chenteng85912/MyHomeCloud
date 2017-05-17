//
//  AJMyhouseViewController.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/10.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"

typedef NS_ENUM(NSInteger,HouseShowModal) {
    MyHouseModal,       //我的房源
    FavoriteModal,      //我的收藏
    UserRecordModal,    //浏览记录
};

@interface AJMyhouseViewController : AJBaseTbViewController

@property (assign, nonatomic) HouseShowModal showModal;

@end
