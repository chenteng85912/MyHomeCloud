//
//  AJHomeViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHomeViewController.h"
#import "AJHomeDataCenter.h"
#import "AJHomeHeadView.h"
#import "AJHouseInfoViewController.h"
#import "AJFindHouseViewController.h"
#import "AJSearchViewController.h"
#import "AJFinanceViewController.h"
#import "AJFinanceCellModel.h"

#import "AJSecondHouseViewController.h"
#import "AJSecondHouseCellModel.h"
#import "AJSecondHouseTableViewCell.h"

#import "AJLetHouseViewController.h"
#import "AJLetHouseTableViewCell.h"
#import "AJLetHouseCellModel.h"

#import "AJNewHouseViewController.h"
#import "AJNewHouseTableViewCell.h"
#import "AJNewHouseCellModel.h"
#import "CTAutoLoopViewController.h"

#define AutoLoopHeight dHeight/3
CGFloat const HEAD_BTN_HEIGHT = 100;

@interface AJHomeViewController ()<UISearchBarDelegate,CTAutoLoopViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIView *headBtnView;

@property (strong, nonatomic)  UIView *headSearchView;
@property (strong, nonatomic)  UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray <AJSecondHouseCellModel *> *secondArray;
@property (strong, nonatomic) NSMutableArray <AJLetHouseCellModel *> *letArray;
@property (strong, nonatomic) NSMutableArray <AJNewHouseCellModel *> *newhouseArray;

@property (strong, nonatomic) UIButton *areaBtn;
@property (strong, nonatomic) AJHomeDataCenter *homeData;

//首页App 滚动广告视图
@property (strong, nonatomic) CTAutoLoopViewController * autoLoopView;
//头部广告图片数据
@property (strong, nonatomic) NSMutableArray *autoLoopDataArray;

@property (strong, nonatomic) UIView *headView;

@end

@implementation AJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [self initTbViewData];
    
    [self.view showHUD:nil];
    [self fetchData];
    
    [CTTool removeSearchBorder:self.searchBar];
    //头部广告滚动视图数据源
    [self.autoLoopView addLocalModels:self.autoLoopDataArray];
    
    for (UIButton *btn in _headBtnView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setImage:[btn.currentImage imageChangeThemeColor] forState:UIControlStateNormal];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _tbView.frame = CGRectMake(0, -NAVBAR_HEIGHT+44, dWidth, dHeight-self.tabBarController.tabBar.frame.size.height+NAVBAR_HEIGHT-44);

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

//- (void)setStatusBarColor:(UIColor *)color{
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = color;
//    }
//
//}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    AJSearchViewController *search = [AJSearchViewController new];

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:search];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
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

- (void)fetchData{
    
    WeakSelf;
    //获取头部滚动数据
    [self.homeData fetchHomeHeadDataCompleteHander:^(BOOL success, NSArray *returnValue) {
        [self.autoLoopDataArray removeAllObjects];
        if (success) {
            [self.autoLoopDataArray addObjectsFromArray:returnValue];

        }
        [weakSelf.autoLoopView addLocalModels:self.autoLoopDataArray];

    }];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self.homeData fetchSecondHouseDataCompleteHander:^(BOOL success, NSArray *returnValue) {
            [weakSelf.secondArray removeAllObjects];
            if (success) {
                [weakSelf.secondArray addObjectsFromArray:returnValue];;

            }
            dispatch_group_leave(group);

        }];
    });
   
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self.homeData fetchLetHouseDataCompleteHander:^(BOOL success, NSArray *returnValue) {
            [weakSelf.letArray removeAllObjects];
            if (success) {
                [weakSelf.letArray addObjectsFromArray:returnValue];
                
            }
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self.homeData fetchNewHouseDataCompleteHander:^(BOOL success, NSArray *returnValue) {
            [weakSelf.newhouseArray removeAllObjects];
            if (success) {
                [weakSelf.newhouseArray addObjectsFromArray:returnValue];
                
            }
            dispatch_group_leave(group);
            
        }];
    });
   
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
   
        [weakSelf.tbView.mj_header endRefreshing];
        [self.view removeHUD];

        [weakSelf.tbView reloadData];
        
    });
}
#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return _secondArray.count;
    }else if (section==1){
        return _letArray.count;
    }else{
        return _newhouseArray.count;
    }
   
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section==0) {
        AJSecondHouseTableViewCell *secondCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AJSecondHouseTableViewCell class]) forIndexPath:indexPath];
        [secondCell processCellData:_secondArray[indexPath.row]];
        cell = secondCell;
        
    }else if (indexPath.section==1) {
        AJLetHouseTableViewCell *letCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AJLetHouseTableViewCell class]) forIndexPath:indexPath];
        [letCell processCellData:_letArray[indexPath.row]];

        cell = letCell;
    }else{
         AJNewHouseTableViewCell *nCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AJNewHouseTableViewCell class]) forIndexPath:indexPath];
        [nCell processCellData:_newhouseArray[indexPath.row]];

        cell = nCell;
    }
    
    return cell;
}
#pragma mark UITableViewDelegate UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return _secondArray[indexPath.row].cellHeight;
    }else if (indexPath.section==1) {
        return _letArray[indexPath.row].cellHeight;

    }else{
        return _newhouseArray[indexPath.row].cellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    AJHomeHeadView *headView = [AJHomeHeadView initWithSection:section];
    headView.arrowImg.image = [headView.arrowImg.image imageChangeThemeColor];
    BUTTON_ACTION(headView.headBtn, self, @selector(openMoreHouseData:));
    
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    AJHouseInfoViewController *details = [AJHouseInfoViewController new];
    details.showModal = SearchHouseModal;
    AJTbViewCellModel *model;
    NSString *className;

    if (indexPath.section==0) {
        model = self.secondArray[indexPath.row];
        details.detailsModal = SecondModal;
        className = SECOND_RECORD;
        details.searchKey = model.objectData[HOUSE_ESTATE_NAME];

    }else if (indexPath.section==1){
        model = self.letArray[indexPath.row];
        details.detailsModal = LetModal;
        className = LET_RECORD;
        details.searchKey = model.objectData[HOUSE_ESTATE_NAME];

    }else{
        details.detailsModal = NModal;
        model = self.newhouseArray[indexPath.row];
        className = N_RECORD;
        details.searchKey = model.objectData[HOUSE_AREA];

    }
    details.houseId = model.objectData.objectId;
    details.hidesBottomBarWhenPushed = YES;
    APP_PUSH(details);
    
    [[AJHomeDataCenter new] addRecordData:model.objectData recordClassName:className];

}

#pragma mark CTAutoLoopViewDelegate
- (UIView *)CTAutoLoopViewController:(UICollectionViewCell *)collectionCell cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.autoLoopView.view.frame];
    imgView.contentMode = UIViewContentModeScaleAspectFill;

    AVObject *headObj = self.autoLoopDataArray[indexPath.row];
    [imgView sd_setImageWithURL:[NSURL URLWithString:headObj[HOME_IMAGE_URL]] placeholderImage:LOADIMAGE(@"defaultImg")];
    
    return imgView;
}
- (void)CTAutoLoopViewController:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AVObject *headObj = self.autoLoopDataArray[indexPath.row];
    
    AJFinanceViewController *finance = [AJFinanceViewController new];
    finance.isOneModal = YES;
    finance.isLoad = YES;
    finance.title = headObj[HOME_IMAGE_TITILE];
    
    AJFinanceCellModel *model = [AJFinanceCellModel new];
    model.objectData = headObj;
    [model calculateSizeConstrainedToSize];
    [finance.dataArray addObject:model];
    
    finance.hidesBottomBarWhenPushed = YES;
    APP_PUSH(finance);
    
}
- (void)openMoreHouseData:(UIButton *)btn{
    UIViewController *vc;
    if (btn.tag==0) {
        AJSecondHouseViewController *second = [AJSecondHouseViewController new];
        second.showModal = AllHouseModal;
        second.className = SECOND_HAND_HOUSE;
        second.showFilter = YES;
        vc = second;
    }else if (btn.tag==1){
        AJLetHouseViewController *let = [AJLetHouseViewController new];
        let.showModal = AllHouseModal;
        let.className = LET_HOUSE;
        let.showFilter = YES;

        vc = let;

    }else if (btn.tag==2){
        AJNewHouseViewController *newHouse = [AJNewHouseViewController new];
        newHouse.showModal = AllHouseModal;
        newHouse.className = N_HOUSE;
        newHouse.showFilter = YES;

        vc = newHouse;
    }else {
        AJFinanceViewController *finance = [AJFinanceViewController new];
        finance.title = @"安家金服";
        vc = finance;
       
    }
    vc.hidesBottomBarWhenPushed = YES;
    APP_PUSH(vc);
}
- (void)initTbViewData{
//    self.navigationItem.titleView = self.searchBar;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.areaBtn];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"安家屋" style:UIBarButtonItemStylePlain target:self action:nil];

    [_tbView registerNib:[UINib nibWithNibName:NSStringFromClass([AJSecondHouseTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AJSecondHouseTableViewCell class])];
    
    [_tbView registerNib:[UINib nibWithNibName:NSStringFromClass([AJLetHouseTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AJLetHouseTableViewCell class])];
    
    [_tbView registerNib:[UINib nibWithNibName:NSStringFromClass([AJNewHouseTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AJNewHouseTableViewCell class])];
    
    _tbView.tableHeaderView = self.headView;
    _tbView.mj_header = [CTTool makeMJRefeshWithTarget:self andMethod:@selector(fetchData)];
}
- (IBAction)btnAction:(UIButton *)sender {
    [self openMoreHouseData:sender];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat alpha = (scrollView.contentOffset.y +[[UIApplication sharedApplication] statusBarFrame].size.height) / 100;
//    debugLog(@"alpha:%f",alpha);
    self.headSearchView.backgroundColor = [NavigationBarColor colorWithAlphaComponent:alpha];
    if (alpha<=0) {
        self.searchBar.alpha = 1-3*fabs(alpha);
        
    }

}

- (CTAutoLoopViewController *)autoLoopView
{
    if (!_autoLoopView) {
        _autoLoopView = [CTAutoLoopViewController initWithFrame:CGRectMake(0, 0, dWidth, AutoLoopHeight) onceLoopTime:3.0 cellDisplayModal:CTLoopCellDisplayCustomView scollDiretion:CTLoopScollDirectionHorizontal];
        _autoLoopView.delegate = self;
        [self addChildViewController:_autoLoopView];
    }
    return _autoLoopView;
}
- (NSMutableArray *)autoLoopDataArray{
    if (!_autoLoopDataArray) {
        _autoLoopDataArray = [NSMutableArray new];
    }

    return _autoLoopDataArray;
}
- (AJHomeDataCenter *)homeData{
    if (_homeData ==nil) {
        _homeData = [AJHomeDataCenter new];
    }
    return _homeData;
}

- (UIView *)headView{
    if (_headView ==nil) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dWidth, AutoLoopHeight+HEAD_BTN_HEIGHT)];
        [_headView addSubview:self.autoLoopView.view];
        _headBtnView.frame = CGRectMake(0, AutoLoopHeight, dWidth, HEAD_BTN_HEIGHT);
        [_headView addSubview:_headBtnView];
    }
    return _headView;
}

- (NSMutableArray <AJSecondHouseCellModel *> *)secondArray{
    if (_secondArray==nil) {
        _secondArray = [NSMutableArray new];
    }
    return _secondArray;
}
- (NSMutableArray <AJLetHouseCellModel *> *)letArray{
    if (_letArray==nil) {
        _letArray = [NSMutableArray new];
    }
    return _letArray;
}

- (NSMutableArray <AJNewHouseCellModel *> *)newhouseArray{
    if (_newhouseArray==nil) {
        _newhouseArray = [NSMutableArray new];
    }
    return _newhouseArray;
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

- (UIView *)headSearchView{
    if (!_headSearchView) {
        _headSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,dWidth, NAVBAR_HEIGHT)];
        _headSearchView.backgroundColor = [NavigationBarColor colorWithAlphaComponent:0];
        [self.view addSubview:_headSearchView];
    }
    return _headSearchView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, NAVBAR_HEIGHT-44, dWidth-40, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"小区/开发商/区域";
        UIView *searchTextField = [[[_searchBar.subviews firstObject] subviews] lastObject];
        searchTextField.layer.masksToBounds = YES;
        [self.headSearchView addSubview:_searchBar];
    }
    return _searchBar;
}
@end
