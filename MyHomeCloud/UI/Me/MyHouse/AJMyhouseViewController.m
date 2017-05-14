//
//  AJMyhouseViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/10.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJMyhouseViewController.h"
#import "AJNewHouserViewController.h"
#import "AJHouseDetailsViewController.h"
#import "AJHomeTableViewCell.h"
#import "AJHomeCellModel.h"

@interface AJMyhouseViewController ()

@end

@implementation AJMyhouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.showModal==MyHouseModal) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewHouse)];
        self.navigationItem.rightBarButtonItem.tintColor = NavigationBarColor;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:kHomeHouseNotification object:nil];

   
}
#pragma mark - AJTbViewProtocol
- (BOOL)makeMJRefresh{
    return YES;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    if (self.showModal==MyHouseModal) {
        return HOUSE_INFO;

    }else if (self.showModal == FavoriteModal){
        return FAVORITE_HOUSE;

    }else{
        return RECORD_HOUSE;

    }
}
- (NSString *)requestKeyName{
    return USER_PHONE;
}

//- (BOOL)canDeleteCell{
//    return YES;
//}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJHomeTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJHomeCellModel class]);
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJHomeCellModel *model = (AJHomeCellModel *)self.dataArray[indexPath.row];
    AJHouseDetailsViewController *details = [AJHouseDetailsViewController new];
    details.houseInfo = model.objectData;
    details.hidesBottomBarWhenPushed = YES;

    APP_PUSH(details);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)addNewHouse{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[AJNewHouserViewController new]];
    APP_PRESENT(nav);
}

- (void)refreshHomeData{
    [self.tableView.mj_header beginRefreshing];
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
