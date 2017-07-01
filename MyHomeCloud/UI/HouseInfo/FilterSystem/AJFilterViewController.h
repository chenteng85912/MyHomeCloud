//
//  AJFilterViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/28.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CTBaseViewController.h"

@protocol AJFilterViewControllerDelegate <NSObject>

- (void)refreshTbView;

@end
@interface AJFilterViewController : CTBaseViewController

@property (assign, nonatomic) NSString *className;
@property (strong, nonatomic) NSMutableDictionary  *filterDic;//条件

@property (weak, nonatomic) id <AJFilterViewControllerDelegate> delegate;

- (void)showOrHiddenTbView:(BOOL)isShow;

@end
