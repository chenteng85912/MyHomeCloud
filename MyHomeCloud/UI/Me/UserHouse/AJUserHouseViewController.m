//
//  AJUserHouseViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/6.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJUserHouseViewController.h"
#import "AJSecondHouseViewController.h"
#import "AJLetHouseViewController.h"
#import "AJNewHouseViewController.h"
#import "AJAddSecondHouserViewController.h"

@interface AJUserHouseViewController ()

@property (strong, nonatomic) CTPageController *pageVC;
@property (assign, nonatomic) NSInteger currentPageNum;

@end

@implementation AJUserHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.showModal==MyHouseModal) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewHouse)];

    }
    [self initRootVC];
}
- (void)addNewHouse{
    if (_currentPageNum==0) {
        
        AJAddSecondHouserViewController *add = [AJAddSecondHouserViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:add];
        APP_PRESENT(nav);
    }
    
}
- (void)initRootVC{
    
    AJSecondHouseViewController *second = [AJSecondHouseViewController new];
    second.showModal = _showModal;
    second.title  =@"二手房";
    
    AJLetHouseViewController *let = [AJLetHouseViewController new];
    let.showModal = _showModal;
    let.title  =@"租房";

    if (_showModal==UserFavoriteModal||_showModal==UserRecordModal) {
        //二手房 新房 租房
        AJNewHouseViewController *house = [AJNewHouseViewController new];
        house.showModal = _showModal;
        house.title  =@"新房";

        self.pageVC.viewControllers = @[second,let,house];

    }else{
        //二手房 出租房
        self.pageVC.viewControllers = @[second,let];
        if (_showModal==MyHouseModal) {
            self.pageVC.scrollBlock = ^(NSInteger pageNum){
                _currentPageNum = pageNum;
            };
        }

    }
    self.pageVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.pageVC.view];
    [self addChildViewController:self.pageVC];

}
- (CTPageController *)pageVC{
    if (_pageVC==nil) {
        _pageVC = [CTPageController new];
        _pageVC.selectedColor = NavigationBarColor;
        _pageVC.lineShowMode = UnderShowMode;
    }
    return _pageVC;
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