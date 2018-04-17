//
//  UIButton+TYKYButtonBlock.h
//  webhall
//
//  Created by chenteng on 2017/8/3.
//  Copyright © 2017年 Shenzhen Taiji Software Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CustomBtnBlock)(UIButton *sender);

@interface UIButton (CTButtonBlock)

- (void)blockWithControlEvents:(UIControlEvents)controlEvents  block:(CustomBtnBlock)btnBlcok;

@end
