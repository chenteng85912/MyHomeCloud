//
//  AJMyhouseViewController.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/10.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"

typedef NS_ENUM(NSInteger,MYHouseShowModal) {
    AllHouseModal,      //所有房源
    MyHouseModal,       //我的房源
    FavoriteModal,      //我的收藏
    UserRecordModal,    //浏览记录
    SomeoneHouseModal,   //某个用户的房源

};

@interface AJMyhouseViewController : AJBaseTbViewController

@property (assign, nonatomic) MYHouseShowModal showModal;

@property (strong, nonatomic) AVObject *someoneUser;
@end
