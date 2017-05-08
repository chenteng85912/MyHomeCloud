//
//  UIAlertController+TYKYAlertBlock.h
//  webhall
//
//  Created by tjsoft on 2017/3/23.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TouchBlock)(NSInteger buttonIndex);

@interface UIAlertController (TYKYAlertBlock)

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
     cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles
        preferredStyle:(UIAlertControllerStyle)alertStyle
                 block:(TouchBlock)block;

@end
