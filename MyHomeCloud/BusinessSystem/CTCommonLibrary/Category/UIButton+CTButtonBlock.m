//
//  UIButton+TYKYButtonBlock.m
//  webhall
//
//  Created by chenteng on 2017/8/3.
//  Copyright © 2017年 Shenzhen Taiji Software Co., Ltd. All rights reserved.
//

#import "UIButton+CTButtonBlock.h"
#import <objc/runtime.h>
static  NSString const *btn_target_key = @"CustomBtnKey";

@implementation UIButton (CTButtonBlock)

- (void)blockWithControlEvents:(UIControlEvents)controlEvents block:(CustomBtnBlock)btnBlcok{
    [self addActionBlock:btnBlcok];
    [self addTarget:self action:@selector(invoke:) forControlEvents:controlEvents];
}

- (void)addActionBlock:(CustomBtnBlock)block {
    if (block) {
        objc_setAssociatedObject(self, &btn_target_key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)invoke:(id)sender {
    CustomBtnBlock block = objc_getAssociatedObject(self, &btn_target_key);
    if (block) {
        block(sender);
    }
}
@end
