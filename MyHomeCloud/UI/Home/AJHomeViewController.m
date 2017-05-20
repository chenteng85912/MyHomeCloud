//
//  AJHomeViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHomeViewController.h"
#import "AJHouseViewController.h"
#import "AJSearchViewController.h"


@interface AJHomeViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation AJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AJHouseViewController *house = [AJHouseViewController new];
    house.showModal = HomeHouseModal;
    house.isSubVC = YES;
    [self.view addSubview:house.view];
    [self addChildViewController:house];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.titleView = self.searchBar;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIButton *areaBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [areaBut setTitle:@"东莞" forState:UIControlStateNormal];
    [areaBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    areaBut.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    areaBut.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [areaBut setImage:LOADIMAGE(@"down") forState:UIControlStateNormal];
    areaBut.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaBut];

}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    AJHouseViewController *search = [AJHouseViewController new];
    search.showModal = SearchHouseModal;
    search.isLoad = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:search];
    [nav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:nav animated:YES completion:^{
    }];
    return NO;
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
