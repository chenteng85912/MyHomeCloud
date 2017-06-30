//
//  AJFilterViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/28.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CTBaseViewController.h"

@interface AJFilterViewController : CTBaseViewController

@property (assign, nonatomic) NSString *className;

- (void)showOrHiddenTbView:(BOOL)isShow;

@end
