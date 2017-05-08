//
//  UIAlertController+TYKYAlertBlock.m
//  webhall
//
//  Created by tjsoft on 2017/3/23.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "UIAlertController+TYKYAlertBlock.h"

@implementation UIAlertController (TYKYAlertBlock)

+ (void)alertWithTitle:(NSString *)title
             message:(NSString *)message
   cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles
      preferredStyle:(UIAlertControllerStyle)alertStyle
               block:(TouchBlock)block{
    
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
    if (cancelButtonTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            block(0);
        }]];
    }
    
    for (int i=0; i<otherButtonTitles.count; i++) {
        NSString *title = otherButtonTitles[i];
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (i==0) {
            style = UIAlertActionStyleDestructive;
        }
        [alert addAction:[UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            block(i+1);
        }]];
    }
    
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
        UIViewController *presentedVC = (UIViewController *)[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
        if (presentedVC.presentedViewController) {
            [presentedVC.presentedViewController presentViewController:alert animated:YES completion:nil];
            return;
        }
        [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:alert animated:YES completion:nil];
        
    }else{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        
    }

}

@end
