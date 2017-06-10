//
//  AJHouseDetailsViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"

typedef NS_ENUM(NSInteger,DetailsHouseModal) {
    SecondHouseModal,    //二手房
    LetHouseModal,       //租房
};
@interface AJHouseDetailsViewController : AJBaseTbViewController

@property (strong, nonatomic) AVObject *houseInfo;

@property (assign, nonatomic) BOOL isFromFav;//来自我的收藏
@property (assign, nonatomic) DetailsHouseModal detailsModal;

@end
