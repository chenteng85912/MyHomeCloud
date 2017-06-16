//
//  AJHouseDetailsViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"

typedef NS_ENUM(NSInteger,DetailsHouseModal) {
    SecondModal,    //二手房
    LetModal       //租房
};
@interface AJHouseDetailsViewController : AJBaseTbViewController

@property (strong, nonatomic) NSString *houseId;
@property (strong, nonatomic) NSString *searchKey;

@property (strong, nonatomic) AJBaseTbViewController *tbView;

@property (assign, nonatomic) DetailsHouseModal detailsModal;

@end
