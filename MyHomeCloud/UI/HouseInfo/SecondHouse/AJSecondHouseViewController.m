//
//  AJSecondHouseViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/6/6.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJSecondHouseViewController.h"
#import "AJSecondHouseTableViewCell.h"
#import "AJSecondHouseCellModel.h"
#import "AJHouseDetailsViewController.h"
#import "AJHomeDataCenter.h"

@interface AJSecondHouseViewController ()<UISearchBarDelegate>

@property (strong, nonatomic)UISearchBar *searchBar;

@end

@implementation AJSecondHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.showModal==SearchHouseModal) {
        self.navigationItem.titleView = self.searchBar;
    }else{
        if (self.showModal==MyHouseModal) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:kNewHouseNotification object:nil];
            
        }
        self.title = @"二手房";

    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

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
        return SECOND_FAVORITE;
        
    }else if (self.showModal == UserRecordModal){
        return SECOND_RECORD;
        
    }else{
        return SECOND_HAND_HOUSE;
        
    }
}
- (NSString *)requestKeyName{
    if (self.showModal==SomeoneHouseModal) {
//        return _someoneUser[@"mobilePhoneNumber"];
        return _someonePhone;
    }else  if (self.showModal==SearchHouseModal){
        return _searchKey;
    }else if (self.showModal==UserFavoriteModal||self.showModal==UserRecordModal||self.showModal ==MyHouseModal){
        return [AVUser currentUser].mobilePhoneNumber;
    }else{
        return nil;
    }
}
- (NSString *)recordClassName{
    return SECOND_RECORD;
}
- (NSString *)pointClassName{
    return SECOND_HAND_HOUSE;
}
- (NSString *)favoriteClassName{
    return SECOND_FAVORITE;
}
- (BOOL)canDeleteCell{
    if (self.showModal==SomeoneHouseModal||self.showModal ==SearchHouseModal||self.showModal==AllHouseModal) {
        return NO;
    }
    return YES;
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJSecondHouseTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJSecondHouseCellModel class]);
}
- (void)loadDataSuccess{
    [self.view removeHUD];
    
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJSecondHouseCellModel *model = (AJSecondHouseCellModel *)self.dataArray[indexPath.row];
    AJHouseDetailsViewController *details = [AJHouseDetailsViewController new];
    details.showModal = SearchHouseModal;
    details.detailsModal = SecondHouseModal;

    if (self.showModal==UserFavoriteModal) {
        details.isFromFav = YES;
        details.tbView = self;
    }
    
    details.houseInfo = model.objectData;
    APP_PUSH(details);
    
    if (self.showModal==AllHouseModal||self.showModal==SomeoneHouseModal) {
        [[AJHomeDataCenter new] addRecordData:model.objectData objectClassName:[self requestClassName] recordClassName:[self recordClassName]];
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

//- (void)addNewHouse{
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[AJAddSecondHouserViewController new]];
//    
//    APP_PRESENT(nav);
//}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    POPVC;
    return NO;
}
- (UISearchBar *)searchBar{
    if (_searchBar ==nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, dWidth, 30)];
        _searchBar.placeholder = @"区域/小区/开发商";
        _searchBar.barTintColor = NavigationBarColor;
        _searchBar.delegate = self;
    }
    return _searchBar;
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
