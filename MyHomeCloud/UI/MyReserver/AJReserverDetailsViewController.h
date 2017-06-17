//
//  AJReserverDetailsViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CTBaseViewController.h"

@class AJReserverCellModel;

@interface AJReserverDetailsViewController : CTBaseViewController

@property (strong, nonatomic) AJReserverCellModel *reserverModal;

- (void)refreshView;
@end
