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

@interface AJMyhouseViewController ()

@end

@implementation AJMyhouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:kNewHouseNotification object:nil];
   
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
    if (self.showModal!=MyHouseModal) {
        details.houseInfo = model.objectData[HOUSE_OBJECT];

    }else{
        details.houseInfo = model.objectData;

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