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
#import "AJAddHouserViewController.h"
#import "AJMyReserverViewController.h"

@interface AJUserHouseViewController ()

@property (strong, nonatomic) CTPageController *pageVC;
@property (assign, nonatomic) NSInteger currentPageNum;

@end

@implementation AJUserHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (self.showModal==MyHouseModal) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewHouse)];

    }
    [self initRootVC];
}
- (void)addNewHouse{
    AJAddHouserViewController *add = [AJAddHouserViewController new];
    if (_currentPageNum==0) {
        
        add.addModal = SecondHouseModal;
    }else{
        add.addModal = LetHouseModal;

    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:add];

    APP_PRESENT(nav);

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

    }else if (_showModal==ReserverHouseModal){
        AJMyReserverViewController *secondr = [AJMyReserverViewController new];
        secondr.reserverModal = SecondReserverModal;
        secondr.title  =@"二手房";
        secondr.showModal = _showModal;

        AJMyReserverViewController *letr = [AJMyReserverViewController new];
        letr.reserverModal = LetReserverModal;
        letr.title  =@"租房";
        letr.showModal = _showModal;

        self.pageVC.viewControllers = @[secondr,letr];

    }else{
        //二手房 出租房
        self.pageVC.viewControllers = @[second,let];
        if (_showModal==MyHouseModal) {
            self.pageVC.scrollBlock = ^(NSInteger pageNum){
                _currentPageNum = pageNum;
            };
        }
        if (_showModal==SomeoneHouseModal) {
            second.someonePhone = _someonePhone;
            let.someonePhone  = _someonePhone;
        }
        if (_showModal==AllHouseModal) {
            //二手房 新房 租房
            AJNewHouseViewController *house = [AJNewHouseViewController new];
            house.showModal = _showModal;
            house.title  =@"新房";
            
            self.pageVC.viewControllers = @[second,let,house];
#if AJCLOUDADMIN
            second.isAmindModal = YES;
            let.isAmindModal = YES;
            house.isAmindModal = YES;
#endif
        }

    }
    self.pageVC.view.frame = self.view.bounds;
    [self.view addSubview:self.pageVC.view];

}
- (CTPageController *)pageVC{
    if (_pageVC==nil) {
        _pageVC = [CTPageController new];
        _pageVC.selectedColor = NavigationBarColor;
        _pageVC.lineShowMode = UnderShowMode;
        [self addChildViewController:_pageVC];

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
