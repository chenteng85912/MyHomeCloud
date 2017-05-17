//
//  AJHomeViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHomeViewController.h"
#import "AJHouseViewController.h"

@interface AJHomeViewController ()

@end

@implementation AJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AJHouseViewController *house = [AJHouseViewController new];
    [self.view addSubview:house.view];
    [self addChildViewController:house];
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
