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
#import "AJNewsViewController.h"


@interface AjMainTabBarViewController ()<UITabBarControllerDelegate>

@property (strong, nonatomic) UINavigationController *currunNav;
@end

@implementation AjMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRootViewController];

   
}

//初始化根视图控制器
- (void)initRootViewController{
    
    AJHomeViewController *home = [AJHomeViewController new];
    home.title = @"首页";
    
    AJNewsViewController *news = [AJNewsViewController new];
    news.title = @"消息";
    
    AJUserCenterViewController *user = [AJUserCenterViewController new];
    user.title = @"我";
    
    NSArray *normalImgs = @[@"home_nor",@"msg",@"user"];
    NSArray *selectedImgs = @[@"home_sel",@"msg_sel",@"user_sel"];
    NSArray *viewControllers = @[home,news,user];
    
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:viewControllers.count];
    for (int i = 0; i < viewControllers.count;i++) {
        UIViewController *vc = viewControllers[i];
        vc.tabBarItem.image = [[UIImage imageNamed:normalImgs[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImgs[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:NavigationBarColor} forState:UIControlStateSelected];
        vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
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
