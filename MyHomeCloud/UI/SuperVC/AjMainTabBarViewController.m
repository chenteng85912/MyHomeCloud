//
//  TJMainTabBarViewController.m
//  webhall
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import "AjMainTabBarViewController.h"
#import "AJHomeViewController.h"
#import "AJUserCenterViewController.h"
#import "AJMessageController.h"
#import "AJRemoteNotification.h"

@interface AjMainTabBarViewController ()<UITabBarControllerDelegate>

@property (strong, nonatomic) UINavigationController *currunNav;
@end

@implementation AjMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRootViewController];
    [self performSelector:@selector(showRemoteNotificationAlert) withObject:nil afterDelay:30.0];

   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    
}
- (void)showRemoteNotificationAlert{
    [AJRemoteNotification checkUserNotificationSetting];
    
}
//初始化根视图控制器
- (void)initRootViewController{
    
    AJHomeViewController *home = [AJHomeViewController new];
    home.title = @"首页";
    
    AJMessageController *news = [AJMessageController new];
    news.title = @"消息";
    
    AJUserCenterViewController *user = [AJUserCenterViewController new];
    user.title = @"我";
    
    NSArray *normalImgs = @[@"home",@"message",@"me"];

    self.tabBar.tintColor = NavigationBarColor;
    self.tabBar.translucent = NO;
    NSArray *viewControllers = @[home,news,user];
    
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:viewControllers.count];
    for (int i = 0; i < viewControllers.count;i++) {
        UIViewController *vc = viewControllers[i];
//        vc.tabBarItem.image = [[UIImage imageNamed:normalImgs[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.image = [UIImage imageNamed:normalImgs[i]];

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [newArray addObject:nav];
    }

    self.viewControllers = newArray;
    self.delegate = self;
    _currunNav = self.viewControllers[0];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    UINavigationController *nav = (UINavigationController *)viewController;

//    CTBaseViewController *base = _currunNav.viewControllers[0];
    _currunNav = nav;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
