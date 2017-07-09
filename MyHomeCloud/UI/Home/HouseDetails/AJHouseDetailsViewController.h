//
//  AJHouseDetailsViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"

extern CGFloat const INFO_NORMAL_HEITHT;
extern CGFloat const MAP_HEIGHT;

typedef NS_ENUM(NSInteger,DetailsHouseModal) {
    SecondModal,   //二手房
    LetModal,      //租房
    NModal         //新房
};
#define AUTOLOOP_HEIGHT     dHeight/3

@interface AJHouseDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mapBView
;
@property (weak, nonatomic) IBOutlet UIButton *moreInfoBtn;
@property (strong, nonatomic) AVObject *houseInfo;//当前房源信息

@property (assign, nonatomic) DetailsHouseModal detailsModal;

- (void)initHouseDetailsInfo;
@end
