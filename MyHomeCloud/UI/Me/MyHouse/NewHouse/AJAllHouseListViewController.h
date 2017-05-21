//
//  AJAllHouseListViewController.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/21.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"

@protocol AJAllHouseListViewControllerDelegate <NSObject>

- (void)chooseHouseInfo:(AVObject *)houseInfo;

@end

@interface AJAllHouseListViewController : AJBaseTbViewController

@property (nonatomic,weak) id <AJAllHouseListViewControllerDelegate> delegate;

@end
