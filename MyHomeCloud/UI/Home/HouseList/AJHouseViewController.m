//
//  AJHonmeViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/9.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHouseViewController.h"
#import "AJHomeTableViewCell.h"
#import "AJHouseDetailsViewController.h"
#import "AJHomeCellModel.h"

CGFloat const HEAD_BUTTON_HEIGHT  = 0.0;

@interface AJHouseViewController ()<UISearchBarDelegate,CTAutoLoopViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headBtnView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITapGestureRecognizer *tapGes;
//首页App 滚动广告视图
@property (strong, nonatomic) CTAutoLoopViewController * autoLoopView;
//头部广告图片数据
@property (strong, nonatomic) NSMutableArray *autoLoopDataArray;
@property (strong, nonatomic) UIView *headView;

@end

@implementation AJHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.showModal==HomeHouseModal) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:kHomeHouseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:kNewHouseNotification object:nil];
    }else if (self.showModal==SearchHouseModal){
        if (self.searchKey) {
            self.title= @"更多相似房源";
        }else{
            [self.view addGestureRecognizer:self.tapGes];
            self.navigationItem.titleView = self.searchBar;
            [self.searchBar becomeFirstResponder];
        }
      
    }else{
        if (_userObj) {
            self.title = _userObj[USER_NICKNAME];
        }
    }
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.showModal==SearchHouseModal&&self.dataArray.count==0&&!self.searchKey) {
        [self.tableView addNoDataTipView];

    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark - AJTbViewProtocol
- (BOOL)makeMJRefresh{
    if (self.showModal==HomeHouseModal||self.searchKey) {

        return YES;
    }
    
    return NO;
    
}
- (BOOL)firstShowAnimation{
    return YES;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    return HOUSE_INFO;
}
- (NSString *)requestKeyName{
    if (self.showModal==SearchHouseModal) {
        if (self.searchKey) {
            return self.searchKey;
        }
        return self.searchBar.text;
    }else if(self.showModal==SomeoneHouseModal){
        return _userObj.mobilePhoneNumber;
    }else{
        return nil;

    }
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJHomeTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJHomeCellModel class]);
}
- (void)loadDataSuccess{
    [self.view removeHUD];
    if (self.showModal==HomeHouseModal) {
        self.tableView.tableHeaderView = self.headView;

    }

}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJHomeCellModel *model = (AJHomeCellModel *)self.dataArray[indexPath.row];
    AJHouseDetailsViewController *details = [AJHouseDetailsViewController new];
    details.houseInfo = model.objectData;
    details.hidesBottomBarWhenPushed = YES;
    details.isSubVC = YES;

    APP_PUSH(details);
    [self addRecordData:model.objectData];

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    return 0.01;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//保存浏览记录
- (void)addRecordData:(AVObject *)object{
    AVObject *houseInfo = [[AVObject alloc] initWithClassName:RECORD_HOUSE];
    [houseInfo setObject:object.objectId forKey:HOUSE_ID];
    [houseInfo setObject:[AVUser currentUser].mobilePhoneNumber forKey:USER_PHONE];
    
    [houseInfo setObject:[AVObject objectWithClassName:HOUSE_INFO objectId:object.objectId] forKey:HOUSE_OBJECT];
    [houseInfo setObject:[AVObject objectWithClassName:USER_INFO objectId:[AVUser currentUser].objectId] forKey:HOUSE_AUTHOR];

    self.baseQuery.className = RECORD_HOUSE;
    [self.baseQuery whereKey:HOUSE_ID equalTo:object.objectId];
    [self.baseQuery whereKey:USER_PHONE equalTo:[AVUser currentUser].mobilePhoneNumber];

    [self.baseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            return;
           
        }
        [houseInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                
            }
        }];
    }];

}
//刷新数据
- (void)refreshHomeData{
    [self.view showHUD:nil];
    [self initStartData];
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.view addGestureRecognizer:self.tapGes];
    return YES;
}
/*键盘上的搜索按钮*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    [self searchAction:searchBar.text];
}
//跳转到搜索界面
- (void)searchAction:(NSString *)searchKey{
    [self refreshHomeData];
}
- (void)hiddenKeyBoard{
    [self.searchBar resignFirstResponder];
    [self.view removeGestureRecognizer:self.tapGes];
}
- (void)backToPreVC{
    [self.searchBar resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark CTAutoLoopViewDelegate
- (void)CTAutoLoopViewController:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   }
- (UISearchBar *)searchBar{
    if (_searchBar ==nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, dWidth, 30)];
        _searchBar.placeholder = @"区域/小区/开发商";
        _searchBar.delegate = self;
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.enablesReturnKeyAutomatically = YES;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _searchBar;
}
- (UITapGestureRecognizer *)tapGes{
    if (_tapGes ==nil) {
        _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    }
    return _tapGes;
}
-(CTAutoLoopViewController*)autoLoopView
{
    if (!_autoLoopView) {
        _autoLoopView = [[CTAutoLoopViewController alloc] initWithFrame:CGRectMake(0, 0, dWidth, dHeight/4) onceLoopTime:3.0 cellDisplayModal:CTLoopCellDisplayImage scollDiretion:CTLoopScollDirectionHorizontal];
        _autoLoopView.delegate = self;
        //头部广告滚动视图数据源
        [_autoLoopView addLocalModels:self.autoLoopDataArray];
    }
    return _autoLoopView;
}
- (UIView*)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dWidth, dHeight/4+HEAD_BUTTON_HEIGHT)];
        [_headView addSubview:self.autoLoopView.view];
        _headBtnView.frame = CGRectMake(0, dHeight/4, dWidth,HEAD_BUTTON_HEIGHT);
        [_headView addSubview:self.headBtnView];
    }
    return _headView;
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
