//
//  AJHonmeViewController.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/9.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"


@interface AJHouseViewController : AJBaseTbViewController
@property (strong, nonatomic) NSString *searchKey;//房屋详情界面 进入查看更多相似房源 传入关键字
@property (strong, nonatomic) AVUser *userObj;

@end
