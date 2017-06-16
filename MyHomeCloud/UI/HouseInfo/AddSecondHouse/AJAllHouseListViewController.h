//
//  AJAllHouseListViewController.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/21.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"

typedef NS_ENUM(NSInteger,HouseListModal) {
    DefaultListModal,    //默认
    SearchListModal      //搜索
};

@protocol AJAllHouseListViewControllerDelegate <NSObject>

- (void)chooseHouseInfo:(AVObject *)houseInfo;

@end

@interface AJAllHouseListViewController : AJBaseTbViewController

@property (nonatomic,weak) id <AJAllHouseListViewControllerDelegate> delegate;

@property (nonatomic,assign) HouseListModal listModal;

@end
