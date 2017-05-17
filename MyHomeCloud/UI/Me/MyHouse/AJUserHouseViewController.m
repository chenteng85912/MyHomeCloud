//
//  AJUserHouseViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJUserHouseViewController.h"
#import "AJNewHouserViewController.h"

@interface AJUserHouseViewController ()

@end

@implementation AJUserHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AJMyhouseViewController *house = [AJMyhouseViewController new];
    house.showModal = self.showModal;
    [self.view addSubview:house.view];
    [self addChildViewController:house];
    
    if (self.showModal==MyHouseModal) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewHouse)];
    }

}
- (void)addNewHouse{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[AJNewHouserViewController new]];
    APP_PRESENT(nav);
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
