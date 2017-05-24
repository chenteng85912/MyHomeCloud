//
//  AJUserHeadViewController.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/20.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CTBaseViewController.h"

@protocol AJUserHeadViewControllerDelegate <NSObject>

- (void)uploadSuccess:(UIImage *)image;

@end

@interface AJUserHeadViewController : CTBaseViewController

@property (strong,nonatomic) UIImage *headImg;
@property (nonatomic,weak) id <AJUserHeadViewControllerDelegate> delegate;

@end
