//
//  AJNewHouserViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/12.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CTBaseViewController.h"
typedef NS_ENUM(NSInteger,AddHouseModal) {
    SecondHouseModal,   //二手房源
    LetHouseModal      //出租房源
};
@interface AJAddHouserViewController : CTBaseViewController

@property (assign, nonatomic) AddHouseModal addModal;

@end
