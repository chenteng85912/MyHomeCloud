//
//  AJLetHouseViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/6.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJLetHouseViewController.h"
#import "AJLetHouseCellModel.h"
#import "AJLetHouseTableViewCell.h"
#import "AJHouseDetailsViewController.h"
#import "AJHomeDataCenter.h"

@interface AJLetHouseViewController ()

@end

@implementation AJLetHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"租房";

    if (self.showModal==MyHouseModal) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:kNewHouseNotification object:nil];
        
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
        return LET_FAVORITE;
        
    }else if (self.showModal == UserRecordModal){
        return LET_RECORD;
        
    }else{
        return LET_HOUSE;
        
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
- (NSString *)pointClassName{
    return LET_HOUSE;
}
- (NSString *)recordClassName{
    return LET_RECORD;
}
- (NSString *)favoriteClassName{
    return LET_FAVORITE;
}
- (BOOL)canDeleteCell{
    if (self.showModal==SomeoneHouseModal||self.showModal ==SearchHouseModal||self.showModal==AllHouseModal) {
        return NO;
    }
    return YES;
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJLetHouseTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJLetHouseCellModel class]);
}
- (void)loadDataSuccess{
    [self.view removeHUD];
    
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJLetHouseCellModel *model = (AJLetHouseCellModel *)self.dataArray[indexPath.row];
    AJHouseDetailsViewController *details = [AJHouseDetailsViewController new];
    details.houseInfo = self.dataArray[indexPath.row].objectData;
    details.detailsModal = SecondModal;
    details.showModal = SearchHouseModal;

    if (self.showModal==UserFavoriteModal) {
        details.isFromFav = YES;
        details.tbView = self;
    }
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
