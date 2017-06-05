//
//  AJMyhouseViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/10.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJMyhouseViewController.h"
#import "AJHouseDetailsViewController.h"
#import "AJHomeTableViewCell.h"
#import "AJHomeCellModel.h"
#import "AJNewHouserViewController.h"
#import "AJHouseViewController.h"

@interface AJMyhouseViewController ()

@end

@implementation AJMyhouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.showModal==MyHouseModal) {
        //添加新房源
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewHouse)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:kNewHouseNotification object:nil];

    }
    if (self.showModal ==AllHouseModal){
        //搜索
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewHouse)];
    }
    if (self.showModal ==SomeoneHouseModal){
        
    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma mark - AJTbViewProtocol
- (BOOL)makeMJRefresh{
    if (self.showModal==SearchHouseModal) {
        return NO;
    }
    return YES;
}
- (BOOL)firstShowAnimation{
    return YES;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    if (self.showModal == FavoriteModal){
        return USER_FAVORITE;

    }else if (self.showModal == UserRecordModal){
        return USER_RECORD;

    }else{
        return SECOND_HAND_HOUSE;

    }
}
- (NSString *)requestKeyName{
    if (self.showModal==SomeoneHouseModal) {
        return _someoneUser[@"mobilePhoneNumber"];
    }else  if (self.showModal==FavoriteModal||self.showModal==UserRecordModal||self.showModal==MyHouseModal){
        return [AVUser currentUser].mobilePhoneNumber;
    }else{
        return self.searchKey;
    }
}

- (BOOL)canDeleteCell{
    if (self.showModal==SomeoneHouseModal) {
        return NO;
    }
    return YES;
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJHomeTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJHomeCellModel class]);
}
- (void)loadDataSuccess{
    [self.view removeHUD];

}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJHomeCellModel *model = (AJHomeCellModel *)self.dataArray[indexPath.row];
    AJHouseDetailsViewController *details = [AJHouseDetailsViewController new];
    details.isSubVC = YES;
    details.showModal = SearchHouseModal;
    if (self.showModal==FavoriteModal) {
        details.isFromFav = YES;
    }

    details.houseInfo = model.objectData;
    APP_PUSH(details);
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
- (void)addNewHouse{
    UINavigationController *nav;
    if (self.showModal == AllHouseModal) {
        //搜索
        AJHouseViewController *search = [AJHouseViewController new];
        search.showModal = SearchHouseModal;
        search.isLoad = YES;
        nav = [[UINavigationController alloc]initWithRootViewController:search];
        [nav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];

    }else{
        nav = [[UINavigationController alloc] initWithRootViewController:[AJNewHouserViewController new]];

    }
    APP_PRESENT(nav);
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
