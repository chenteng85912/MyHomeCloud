//
//  AJHonmeViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/9.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHonmeViewController.h"
#import "AJLoginViewController.h"

@interface AJHonmeViewController ()

@end

@implementation AJHonmeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![AVUser currentUser]) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[AJLoginViewController new]];
        APP_PRESENT(nav);
        return;
    }
    // Do any additional setup after loading the view from its nib.
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
