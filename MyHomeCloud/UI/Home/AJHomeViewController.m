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
#import "AJOtherViewController.h"
#import "AJSearchViewController.h"

#import "AJSecondHouseViewController.h"
#import "AJSecondHouseCellModel.h"
#import "AJSecondHouseTableViewCell.h"

#import "AJLetHouseViewController.h"
#import "AJLetHouseTableViewCell.h"
#import "AJLetHouseCellModel.h"

#import "AJNewHouseViewController.h"
#import "AJNewHouseTableViewCell.h"
#import "AJNewHouseCellModel.h"

#define AutoLoopHeight 300.0*dWidth/720.0
CGFloat const HEAD_BTN_HEIGHT = 100;

@interface AJHomeViewController ()<CTLocationViewControllerDelegate,CTAutoLoopViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIView *headBtnView;

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
    
    [self initTbViewData];
    
    [self.view showHUD:nil];
    [self fetchData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setStatusBarColor:NavigationBarColor];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setStatusBarColor:[UIColor clearColor]];
}
- (void)setStatusBarColor:(UIColor *)color{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }

}
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

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self.homeData fetchSecondHouseDataCompleteHander:^(BOOL success, NSArray *returnValue) {
            [self.secondArray removeAllObjects];
            if (success) {
                [self.secondArray addObjectsFromArray:returnValue];;

            }
            dispatch_group_leave(group);

        }];
    });
   
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self.homeData fetchLetHouseDataCompleteHander:^(BOOL success, NSArray *returnValue) {
            [self.letArray removeAllObjects];
            if (success) {
                [self.letArray addObjectsFromArray:returnValue];
                
            }
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self.homeData fetchNewHouseDataCompleteHander:^(BOOL success, NSArray *returnValue) {
            [self.newhouseArray removeAllObjects];
            if (success) {
                [self.newhouseArray addObjectsFromArray:returnValue];
                
            }
            dispatch_group_leave(group);
            
        }];
    });
   
    WeakSelf;
    dispatch_group_notify(group, queue, ^{
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tbView.mj_header endRefreshing];
            [weakSelf.view removeHUD];
            [weakSelf.tbView reloadData];
        });
        
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
    
    BUTTON_ACTION(headView.headBtn, self, @selector(openMoreHouseData:));
    
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    AJHouseInfoViewController *details = [AJHouseInfoViewController new];
    details.showModal = SearchHouseModal;
    AJTbViewCellModel *model;
    if (indexPath.section==0) {
        model = self.secondArray[indexPath.row];
        details.detailsModal = SecondModal;
    
        [[AJHomeDataCenter new] addRecordData:model.objectData recordClassName:SECOND_RECORD];
    }else if (indexPath.section==1){
        model = self.letArray[indexPath.row];
        details.detailsModal = LetModal;
        [[AJHomeDataCenter new] addRecordData:model.objectData recordClassName:LET_RECORD];
    }else{
        details.detailsModal = NModal;
        model = self.newhouseArray[indexPath.row];

//        [[AJHomeDataCenter new] addRecordData:self.newhouseArray[indexPath.row].objectData recordClassName:N_RECORD];
    }
    details.searchKey = model.objectData[HOUSE_ESTATE_NAME];
    details.houseId = model.objectData.objectId;
    details.hidesBottomBarWhenPushed = YES;
    APP_PUSH(details);
    
}

#pragma mark CTAutoLoopViewDelegate
- (void)CTAutoLoopViewController:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
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

        vc = newHouse;
    }else{
        AJOtherViewController *other = [AJOtherViewController new];
        vc = other;
        vc.title = @"安家金融";
    }
    vc.hidesBottomBarWhenPushed = YES;
    APP_PUSH(vc);
}
- (void)initTbViewData{
    self.navigationItem.titleView = self.searchBar;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.areaBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"安家屋" style:UIBarButtonItemStylePlain target:self action:nil];

    [_tbView registerNib:[UINib nibWithNibName:NSStringFromClass([AJSecondHouseTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AJSecondHouseTableViewCell class])];
    
    [_tbView registerNib:[UINib nibWithNibName:NSStringFromClass([AJLetHouseTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AJLetHouseTableViewCell class])];
    
    [_tbView registerNib:[UINib nibWithNibName:NSStringFromClass([AJNewHouseTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AJNewHouseTableViewCell class])];
    
    _tbView.tableHeaderView = self.headView;
    _tbView.mj_header = [CTTool makeMJRefeshWithTarget:self andMethod:@selector(fetchData)];

}
- (IBAction)btnAction:(UIButton *)sender {
    [self openMoreHouseData:sender];
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset

{
    [self.navigationController setNavigationBarHidden:velocity.y>0?YES:NO animated:YES];
    
}
- (CTAutoLoopViewController*)autoLoopView
{
    if (!_autoLoopView) {
        _autoLoopView = [[CTAutoLoopViewController alloc] initWithFrame:CGRectMake(0, 0, dWidth, AutoLoopHeight) onceLoopTime:3.0 cellDisplayModal:CTLoopCellDisplayImage scollDiretion:CTLoopScollDirectionHorizontal];
        _autoLoopView.delegate = self;
        //头部广告滚动视图数据源
        [_autoLoopView addLocalModels:self.autoLoopDataArray];
        [self addChildViewController:_autoLoopView];
    }
    return _autoLoopView;
}
- (NSMutableArray *)autoLoopDataArray{
    if (!_autoLoopDataArray) {
        _autoLoopDataArray = [NSMutableArray new];
    }
    
    [_autoLoopDataArray addObject:@"ad1"];
    [_autoLoopDataArray addObject:@"ad2"];
    [_autoLoopDataArray addObject:@"ad3"];

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
