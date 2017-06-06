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
#import "AJAddSecondHouserViewController.h"

@interface AJSecondHouseViewController ()

@end

@implementation AJSecondHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.showModal==MyHouseModal) {
        //添加新房源
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewHouse)];
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
        return USER_FAVORITE;
        
    }else if (self.showModal == UserRecordModal){
        return USER_RECORD;
        
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
    }else if (self.showModal==UserFavoriteModal||self.showModal==UserRecordModal){
        return [AVUser currentUser].mobilePhoneNumber;
    }else{
        return nil;
    }
}
- (NSString *)pointClassName{
    return SECOND_HAND_HOUSE;
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
    details.isSubVC = YES;
    details.showModal = SearchHouseModal;
    if (self.showModal==UserFavoriteModal) {
        details.isFromFav = YES;
    }
    
    details.houseInfo = model.objectData;
    APP_PUSH(details);
    
    if (self.showModal==AllHouseModal) {
        [self addRecordData:model.objectData];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//保存浏览记录
- (void)addRecordData:(AVObject *)object{
    AVObject *houseInfo = [[AVObject alloc] initWithClassName:USER_RECORD];
    [houseInfo setObject:object.objectId        forKey:HOUSE_ID];
    [houseInfo setObject:SECOND_HAND_HOUSE      forKey:HOUSE_TYPE];

    [houseInfo setObject:[AVUser currentUser].mobilePhoneNumber forKey:USER_PHONE];
    
    [houseInfo setObject:[AVObject objectWithClassName:SECOND_HAND_HOUSE objectId:object.objectId] forKey:HOUSE_OBJECT];
    [houseInfo setObject:[AVUser currentUser].objectId  forKey:HOUSE_AUTHOR];
    [houseInfo setObject:[AVUser currentUser][HEAD_URL] forKey:HEAD_URL];
    
    self.baseQuery.className = USER_RECORD;
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
- (void)refreshHomeData{
    [self.view showHUD:nil];
    [self initStartData];
}

//- (void)addNewHouse{
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[AJAddSecondHouserViewController new]];
//    
//    APP_PRESENT(nav);
//}

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
