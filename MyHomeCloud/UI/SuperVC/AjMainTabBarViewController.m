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
#import "AJFindHouseViewController.h"
#import "AJRemoteNotification.h"

@interface AjMainTabBarViewController ()<UITabBarControllerDelegate>

@property (strong, nonatomic) id curruntVC;
@property (strong, nonatomic) AJMessageController *message;
@end

@implementation AjMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = NavigationBarColor;
    self.tabBar.translucent = NO;
    
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
    _curruntVC = home;
    
    
    AJFindHouseViewController *find = [AJFindHouseViewController new];
    find.title = @"找房";
    
    AJMessageController *news = [AJMessageController new];
    news.title = @"消息";
    self.message = news;
    
    AJUserCenterViewController *user = [AJUserCenterViewController new];
    user.title = @"我";
#if AJCLOUD
    NSArray *normalImgs = @[@"home",@"find",@"message",@"me"];
    NSArray *viewControllers = @[home,find,news,user];

#else
    NSArray *normalImgs = @[@"home",@"message",@"me"];
    NSArray *viewControllers = @[home,news,user];

#endif

    
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:viewControllers.count];
    for (int i = 0; i < viewControllers.count;i++) {
        UIViewController *vc = viewControllers[i];
        vc.tabBarItem.image = [UIImage imageNamed:normalImgs[i]];

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [newArray addObject:nav];
    }

    self.viewControllers = newArray;
    self.delegate = self;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    UINavigationController *nav = (UINavigationController *)viewController;

    id message = nav.viewControllers[0];
    if (_curruntVC == message&&[message isKindOfClass:[AJMessageController class]]) {
        [(AJMessageController *)message startFecthData];
        return;
    }
    _curruntVC = message;

}
- (void)updateMessageNumbers:(NSInteger)badgeNum{
    if (badgeNum==0) {
        self.message.tabBarItem.badgeValue = nil;
    }else if (badgeNum>99){
        self.message.tabBarItem.badgeValue = @"99+";

    }else{
        self.message.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)badgeNum];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
