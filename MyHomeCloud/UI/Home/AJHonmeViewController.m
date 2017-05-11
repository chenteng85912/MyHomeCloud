//
//  AJHonmeViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/9.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHonmeViewController.h"
#import "AJMyhouseViewController.h"

@interface AJHonmeViewController ()

@end

@implementation AJHonmeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(openSearch)];
    self.navigationItem.rightBarButtonItem.tintColor = NavigationBarColor;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)openSearch{
    AJMyhouseViewController *test = [AJMyhouseViewController new];
    test.title = @"搜索";
    test.hidesBottomBarWhenPushed = YES;
    APP_PUSH(test);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
