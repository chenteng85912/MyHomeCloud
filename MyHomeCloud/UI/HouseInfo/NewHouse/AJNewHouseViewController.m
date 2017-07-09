//
//  AJNewHouseViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/6.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJNewHouseViewController.h"
#import "AJNewHouseCellModel.h"
#import "AJNewHouseTableViewCell.h"
#import "AJHomeDataCenter.h"
#import "AJSearchViewController.h"
#import "AJHouseInfoViewController.h"

@interface AJNewHouseViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation AJNewHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.showModal==SearchHouseModal||self.showModal==AllHouseModal) {
        self.navigationItem.titleView = self.searchBar;
    }else{
        if (self.showModal==MyHouseModal||self.showModal==UserFavoriteModal) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:kNewHouseNotification object:nil];
            
        }
        self.title = @"新房";
        
    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
#pragma mark - AJTbViewProtocol
- (BOOL)makeMJRefresh{
    
    return YES;
}
- (BOOL)firstShowAnimation{
    return YES;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    if (self.showModal == UserFavoriteModal){
        return N_FAVORITE;
        
    }else if (self.showModal == UserRecordModal){
        return N_RECORD;
        
    }else{
        return N_HOUSE;
        
    }
}

- (NSString *)requestKeyName{
    if (self.showModal==SearchHouseModal){
        return _searchKey;
    }else if (self.showModal==UserFavoriteModal||self.showModal==UserRecordModal){
        return [AVUser currentUser].mobilePhoneNumber;
    }else{
        return nil;
    }
}
//- (NSString *)pointClassName{
//    return N_HOUSE;
//}
- (NSString *)recordClassName{
    return N_RECORD;
}
- (NSString *)favoriteClassName{
    return N_FAVORITE;
}
- (BOOL)canDeleteCell{
    if (self.showModal==SomeoneHouseModal||self.showModal ==SearchHouseModal||self.showModal==AllHouseModal) {
        return NO;
    }
    return YES;
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJNewHouseTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJNewHouseCellModel class]);
}
- (void)loadDataSuccess{
    [self.view removeHUD];
    
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJNewHouseCellModel *model = (AJNewHouseCellModel *)self.dataArray[indexPath.row];
    
    AJHouseInfoViewController *details = [AJHouseInfoViewController new];
    details.showModal = SearchHouseModal;
    details.searchKey = self.dataArray[indexPath.row].objectData[HOUSE_ESTATE_NAME];
    
    if (self.showModal==UserFavoriteModal||self.showModal==UserRecordModal) {
        
        details.houseId = self.dataArray[indexPath.row].objectData[HOUSE_ID];
        
    }else{
        details.houseId = self.dataArray[indexPath.row].objectData.objectId;
        
    }
    
    APP_PUSH(details);
    if (self.showModal==AllHouseModal||self.showModal==SomeoneHouseModal) {
        [[AJHomeDataCenter new] addRecordData:model.objectData recordClassName:[self recordClassName]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)refreshHomeData{
    [self.view showHUD:nil];
    [self initStartData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    if (self.showModal==AllHouseModal) {
        AJSearchViewController *search = [AJSearchViewController new];
        search.type = @2;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:search];
        [nav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        APP_PRESENT(nav);
        return NO;
    }
    POPVC;
    return NO;
}
- (UISearchBar *)searchBar{
    if (_searchBar ==nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, dWidth, 30)];
        _searchBar.placeholder = @"楼盘/开发商/区域";
        _searchBar.barTintColor = NavigationBarColor;
        _searchBar.delegate = self;
    }
    return _searchBar;
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
