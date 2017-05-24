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
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewHouse)];
    }
    if (self.showModal ==AllHouseModal){
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewHouse)];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:kNewHouseNotification object:nil];
   
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
    if (self.showModal==MyHouseModal||self.showModal==AllHouseModal) {
        return HOUSE_INFO;

    }else if (self.showModal == FavoriteModal){
        return FAVORITE_HOUSE;

    }else{
        return RECORD_HOUSE;

    }
}
- (NSString *)requestKeyName{
    if (self.showModal==AllHouseModal) {
        return nil;
    }
    return USER_PHONE;
}

- (BOOL)canDeleteCell{
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
    if (self.showModal==MyHouseModal||self.showModal==AllHouseModal) {
        details.houseInfo = model.objectData;

    }else{
        details.houseInfo = model.objectData[HOUSE_OBJECT];

        if (self.showModal==FavoriteModal) {
            details.isFromFav = YES;
        }
    }
    details.hidesBottomBarWhenPushed = YES;

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
    if (self.showModal == AllHouseModal) {
        AJHouseViewController *search = [AJHouseViewController new];
        search.showModal = SearchHouseModal;
        search.isLoad = YES;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:search];
        [nav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[AJNewHouserViewController new]];
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
