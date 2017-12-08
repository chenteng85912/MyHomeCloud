//
//  TYKYBaseViewController.h
//  MVPProject
//
//  Created by Apple on 2017/1/23.
//  Copyright © 2017年 Yin. All rights reserved.
//


@interface CTBaseViewController : UIViewController

@property (strong, nonatomic) AVQuery *baseQuery;
@property (assign, nonatomic) BOOL isFlip;
@property (assign, nonatomic) BOOL subController;

- (void)backToPreVC;

@end
