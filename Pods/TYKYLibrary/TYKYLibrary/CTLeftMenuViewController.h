//
//  TJMenuViewController.h
//
//  Created by Apple on 2016/11/3.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

/**
 *  使用方法
 *  1、新建一个继承于该类的视图控制器
 *  2、将菜单界面添加到leftMenuView上，并添加子视图控制器
 *  3、将主界面添加到self.view上面，并添加子视图控制器
 */

#import <UIKit/UIKit.h>

@interface CTLeftMenuViewController : UIViewController

@property (strong, nonatomic) UIView *leftMenuView; //左侧菜单母版
@property (assign, nonatomic) BOOL isResponseGesture;//是否响应手势，默认不响应

/**
 *  展示侧边栏
 */
- (void)showMenu;
/**
 *  展示主界面
 */
- (void)showHome;

@end
