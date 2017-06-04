//
//  AJHomeViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHomeViewController.h"
#import "AJMyhouseViewController.h"

@interface AJHomeViewController ()<CTLocationViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *areaBtn;
@end

@implementation AJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.titleView = self.searchBar;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.areaBtn];

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    AJMyhouseViewController *search = [AJMyhouseViewController new];
    search.showModal = SearchHouseModal;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:search];
    [nav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    APP_PRESENT(nav);

    return NO;
}

- (void)chooseAreaAction{
//    CTLocationViewController *location = [CTLocationViewController new];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:location];
//    location.delegate = self;
//    APP_PRESENT(nav);
}
#pragma mark CTLocationViewControllerDelegate
- (void)sendCityName:(NSString *)cityName{
    if (![cityName isEqualToString:@"东莞"]) {
        [[UIApplication sharedApplication].keyWindow showTips:@"该区域暂未开放" withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.areaBtn setTitle:cityName forState:UIControlStateNormal];;
}
- (UIButton *)areaBtn{
    if (_areaBtn ==nil) {
        _areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [_areaBtn setTitle:@"东莞" forState:UIControlStateNormal];
        [_areaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _areaBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _areaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        [_areaBtn setImage:LOADIMAGE(@"down") forState:UIControlStateNormal];
        _areaBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
        [_areaBtn addTarget:self action:@selector(chooseAreaAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _areaBtn;
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
