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

@interface AJNewHouseViewController ()

@end

@implementation AJNewHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - AJTbViewProtocol
- (BOOL)makeMJRefresh{
    
    return YES;
}
//- (BOOL)firstShowAnimation{
//    return YES;
//}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    if (self.showModal == UserFavoriteModal){
        return USER_FAVORITE;
        
    }else if (self.showModal == UserRecordModal){
        return USER_RECORD;
        
    }else{
        return LET_HOUSE;
        
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
- (NSString *)pointClassName{
    return LET_HOUSE;
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
    
    if (self.showModal==AllHouseModal||self.showModal==SomeoneHouseModal) {
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
    [houseInfo setObject:LET_HOUSE      forKey:HOUSE_TYPE];
    
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
