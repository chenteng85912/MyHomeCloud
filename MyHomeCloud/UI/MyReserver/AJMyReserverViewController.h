//
//  AJMyReserverViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"

typedef NS_ENUM(NSInteger,UserReserverModal) {
    SecondReserverModal,  //二手房预约
    LetReserverModal,     //租房预约
    NReserverModal        //新房预约

};
@interface AJMyReserverViewController : AJBaseTbViewController

@property (assign, nonatomic) UserReserverModal reserverModal;
@property (assign, nonatomic) BOOL isNewReserver;

@end
