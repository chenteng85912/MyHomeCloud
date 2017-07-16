//
//  AJHouseInfoViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/9.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"
#import "AJHouseDetailsViewController.h"

@interface AJHouseInfoViewController : AJBaseTbViewController

@property (strong, nonatomic) NSString *houseId;
@property (strong, nonatomic) NSString *searchKey;

@property (assign, nonatomic) DetailsHouseModal detailsModal;

@property (assign, nonatomic) BOOL isChange;//删除或增加了文件 

@end
